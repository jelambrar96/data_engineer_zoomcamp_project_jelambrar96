from datetime import timedelta 
from datetime import datetime

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

    storage_client = Client()
    bucket_name = os.environ.get('BUCKET_NAME')

    flag_bucket_exist = bucket_exists(bucket_name)
    if not flag_bucket_exist:
        return f"ERROR: Bucket {bucket_name} NOT FOUND", 404

    bucket = storage_client.bucket(bucket_name)

    with tempfile.TemporaryDirectory() as output_dir:

        for hour in range(24):

            url = f"https://data.gharchive.org/{date}-{hour}.json.gz"
            file_name = f"{date}-{hour}.json.gz"
            file_path = os.path.join(output_dir, file_name)
            response = requests.get(url)
            with open(file_path, 'wb') as f:
                f.write(response.content)

            blob = bucket.blob(f"gh-archives/raw/{date}/")
            blob.upload_from_string('')

            blob_name = f"gh-archives/raw/{date}/{file_name}"
            blob = bucket.blob(blob_name)
            blob.upload_from_filename(file_path)

    return "Success: download_gh_archive_data. ", 200