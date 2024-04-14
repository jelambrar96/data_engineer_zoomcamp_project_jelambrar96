# import natives
import os

# from import natives
from datetime import timedelta, datetime

# import external dependences
import requests

# import airflow dependences
from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.python_operator import PythonOperator

# Google cloud operators
from airflow.models import Variable

# import google dependences
import google.auth.transport.requests
import google.oauth2.id_token


URL_CLOUD_FUNCTION = os.environ.get('DOWNLOAD_GH_DATA_CLOUD_FUNCTION')
START_DATE_STR = os.environ.get('START_DATE', '2024-04-01')
start_date = datetime.strftime(START_DATE_STR, "%Y-%m-%d")

function_invoke_cf_download = "download_gh_archive_data"
# gcp_conn_id = "sa-med-ml"

auth_req = google.auth.transport.requests.Request()
id_token = google.oauth2.id_token.fetch_id_token(auth_req, URL_CLOUD_FUNCTION)
headers = {'content-type': 'application/json', "Authorization": f"Bearer {id_token}"}


def function_invoke_cf_download(date, hour):
    payload = {'date': date, 'hour': hour }
    try:
        response = requests.post(URL_CLOUD_FUNCTION, json=payload, headers=headers, timeout=60*3)
        if response.status_code == 200:
                output = "Data downloaded"
        else:
            output = 'Error:', response.content
        return output
    except Exception as e:
         return "Error"


# initializing the default arguments
default_args = {
    'start_date': start_date,
    'retries': 3,
    'retry_delay': timedelta(minutes=10)
}

with DAG(
    dag_id='dag_01_download_gh_archive_data',
    default_args=default_args,
    schedule_interval='0 * * * *', # “At minute 0.”
) as dag:
    
    task_start = DummyOperator(task_id='task_start')
    task_end = DummyOperator(task_id='task_end')

    task_invoke_cf_download = PythonOperator(
        task_id="task_invoke_cf_download",
        python_callable=function_invoke_cf_download,
        op_kwargs={'date': '{{ ds }}', 'hour': '{{ execution_date.hour}}'}
    )

    task_start >> task_invoke_cf_download >> task_end
