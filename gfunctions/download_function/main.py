from datetime import timedelta 
from datetime import datetime

import gzip
import io
import json
import os
import tempfile

import requests

from google.cloud.storage import Client


def bucket_exists(bucket_name):
    storage_client = Client()
    try:
        bucket = storage_client.get_bucket(bucket_name)
        return True
    except:
        return False


def download_gh_archive_data(request):

    request_json = request.get_json(silent=True)
    request_args = request.args

    if request_json and 'date' in request_json:
        date = request_json['date']
    elif request_args and 'date' in request_args:
        date = request_args['date']
    else:
        yesterday_datetime = datetime.now() - timedelta(days=1)
        yesterday_date = yesterday_datetime.strftime("%Y-%m-%d")
        date = yesterday_date


    if request_json and 'hour' in request_json:
        hour = request_json['hour']
    elif request_args and 'hour' in request_args:
        hour = request_args['hour']
    else:
        hour = datetime.now().hour
        

    check_file = False
    if request_json and 'check' in request_json:
        check_file = request_json['check']
    elif request_args and 'check' in request_args:
        check_file = request_args['check']
    else:
        check_file = False


    storage_client = Client()
    bucket_name = os.environ.get('BUCKET_NAME')

    flag_bucket_exist = bucket_exists(bucket_name)
    if not flag_bucket_exist:
        return f"ERROR: Bucket {bucket_name} NOT FOUND", 404

    bucket = storage_client.bucket(bucket_name)

    with tempfile.TemporaryDirectory() as output_dir:

        url = f"https://data.gharchive.org/{date}-{hour}.json.gz"
        file_name = f"{date}-{hour}.json.gz"
        file_path = os.path.join(output_dir, file_name)
        response = requests.get(url)

        if response.code != 200:
            return "ERROR: invalid response. ", 404

        if check_file:
            with io.BytesIO(response.content) as data_stream:
                with gzip.open(data_stream, 'rb') as archivo_entrada, \
                    gzip.open(file_path, 'wt', encoding='utf-8') as archivo_salida:
                    for linea in archivo_entrada:
                        try:
                            obj = json.loads(linea.decode('utf-8'))
                            json.dump(obj, archivo_salida)
                            archivo_salida.write('\n')
                        except json.JSONDecodeError:
                            print(f"Error on file {date}-{hour}. Json skipping.")

        else:
            with open(file_path, 'wb') as f:
                f.write(response.content)

        blob = bucket.blob(f"gh-archives/raw/{date}/")
        blob.upload_from_string('')

        blob_name = f"gh-archives/raw/{date}/{file_name}"
        blob = bucket.blob(blob_name)
        blob.upload_from_filename(file_path)

    return "Success: download_gh_archive_data. ", 200