from datetime import timedelta, datetime

from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.operators.dummy_operator import DummyOperator


# initializing the default arguments
default_args = {
    'start_date': datetime(2024, 1, 1),
    'retries': 3,
    'retry_delay': timedelta(hours=2)
}

with DAG(
    dag_id='dag_01_download_gh_archive_data',
    default_args=default_args,
    schedule_interval='0 3 * * *', # At 03:00.
) as dag:
    
    task_start = DummyOperator(task_id='task_start')
    task_end = DummyOperator(task_id='task_end')


    task_start >> task_end
