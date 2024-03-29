from datetime import timedelta, datetime

import requests

from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.python_operator import PythonOperator

# Google cloud operators
from airflow.models import Variable
# from airflow.providers.google.cloud.operators.functions import (
#     CloudFunctionDeleteFunctionOperator,
#     CloudFunctionDeployFunctionOperator,
#     CloudFunctionInvokeFunctionOperator,
# )
import google.auth.transport.requests
import google.oauth2.id_token



# initializing the default arguments
default_args = {
    'start_date': datetime(2024, 3, 29),
    'retries': 3,
    'retry_delay': timedelta(hours=2)
}


function_invoke_cf_download = "download_gh_archive_data"
gcp_conn_id = "sa-med-ml"


env_vars = Variable.get("TPM_ETA_VARS", deserialize_json=True)
project_id = env_vars["GOOGLE_CLOUD_PROJECT_ID"]
location = env_vars["LOCATION"]

url = Variable.get("download_gh_data_cloud_function")

auth_req = google.auth.transport.requests.Request()
id_token = google.oauth2.id_token.fetch_id_token(auth_req, url)
headers = {'content-type': 'application/json', "Authorization": f"Bearer {id_token}"}


def function_invoke_cf_download(date):
    payload = {"date": date}
    try:
        response = requests.post(url, json=payload, headers=headers, timeout=60)
        if response.status_code == 200:
                output = "Data downloaded"
        else:
            output = 'Error:', response.content
        return output
    except Exception as e:
         return "Error"


with DAG(
    dag_id='dag_01_download_gh_archive_data',
    default_args=default_args,
    schedule_interval='0 3 * * *', # At 03:00.
) as dag:
    
    task_start = DummyOperator(task_id='task_start')
    task_end = DummyOperator(task_id='task_end')

    # task_invoke_cf_download = CloudFunctionInvokeFunctionOperator(
    #     task_id = "task_invoke_cf_download",
    #     project_id = project_id,
    #     location = location,
    #     gcp_conn_id = gcp_conn_id,
    #     input_data = {"date": "{{prev_ds}}"},
    #     function_id = function_invoke_cf_download,
    #     dag = dag
    # )

    task_invoke_cf_download = PythonOperator(
        task_id="task_invoke_cf_download",
        python_callable=function_invoke_cf_download,
        op_kwargs={'date': '{{ prev_ds }}'}
    )

    task_start >> task_invoke_cf_download >> task_end
