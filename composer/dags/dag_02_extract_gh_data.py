import os
from datetime import timedelta, datetime

from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.providers.google.cloud.operators.dataproc import (
    DataprocCreateClusterOperator,
    DataprocDeleteClusterOperator,
    DataprocSubmitJobOperator,
    ClusterGenerator
)

from airflow.contrib.operators.bigquery_check_operator import (
    BigQueryCheckOperator,
)

from airflow.providers.google.cloud.operators.bigquery import (
    BigQueryInsertJobOperator
)


START_DATE_STR = os.environ.get('START_DATE', '2024-04-01')
start_date = datetime.strptime(START_DATE_STR, "%Y-%m-%d") + timedelta(days=1)

BIGQUERY_DATASET_ID = os.environ.get("BIGQUERY_DATASET_ID")

GOOGLE_CLOUD_PROJECT_ID = os.environ.get("GOOGLE_CLOUD_PROJECT_ID")
GOOGLE_CLOUD_REGION = os.environ.get("GOOGLE_CLOUD_REGION")
GOOGLE_CLOUD_ZONE = os.environ.get("GOOGLE_CLOUD_ZONE")


GOOGLE_CLOUD_STORAGE_BUCKET = os.environ.get("GOOGLE_CLOUD_STORAGE_BUCKET")
GOOGLE_CLOUD_DATAWAREHOUSE_BUCKET = os.environ.get("GOOGLE_CLOUD_DATAWAREHOUSE_BUCKET")
GOOGLE_CLOUD_DATALAKE_BUCKET = os.environ.get("GOOGLE_CLOUD_DATALAKE_BUCKET")
GOOGLE_CLOUD_STORAGE_SOURCE_FILES = os.environ.get("GOOGLE_CLOUD_STORAGE_SOURCE_FILES")
GOOGLE_CLOUD_STORAGE_DESTINATION_FILES = os.environ.get("GOOGLE_CLOUD_STORAGE_DESTINATION_FILES")

# DATAPROC_PYTHON_SCRIPTS_PATH = os.environ.get("DATAPROC_PYTHON_SCRIPTS_PATH") 
DATAPROC_PYTHON_SCRIPTS_PATH = "gs://jelambrar96-zoomcamp-20240331-dataproc-bucket/dataproc_01_extract_gh_data.py"

DATAPROC_CLUSTER_NAME = os.environ.get("DATAPROC_CLUSTER_NAME")

DATAPROC_MASTER_MACHINE_TYPE = os.environ.get("DATAPROC_MASTER_MACHINE_TYPE")
DATAPROC_WORKER_MACHINE_TYPE = os.environ.get("DATAPROC_WORKER_MACHINE_TYPE")
DATAPROC_MASTER_DISK_SIZE = int(os.environ.get("DATAPROC_MASTER_DISK_SIZE"))
DATAPROC_WORKER_DISK_SIZE = int(os.environ.get("DATAPROC_WORKER_DISK_SIZE"))
# DATAPROC_MASTER_DISK_TYPE = os.environ.get("DATAPROC_MASTER_DISK_TYPE")
# DATAPROC_WORKER_DISK_TYPE = os.environ.get("DATAPROC_WORKER_DISK_TYPE")
DATAPROC_NUM_WORKERS = int(os.environ.get("DATAPROC_NUM_WORKERS"))
DATAPROC_NUM_MASTERS = int(os.environ.get("DATAPROC_NUM_MASTERS"))


# Define pyspark job parameters
dataproc_job = {
    "reference": {"project_id": GOOGLE_CLOUD_PROJECT_ID},
    # "placement": {"cluster_name": GOOGLE_CLOUD_STORAGE_BUCKET},
    "placement": {"cluster_name": DATAPROC_CLUSTER_NAME},
    "pyspark_job": {
        "main_python_file_uri": DATAPROC_PYTHON_SCRIPTS_PATH, # f"{DATAPROC_PYTHON_SCRIPTS_PATH}/dataproc_01_extract_gh_data.py",
        "args": [
            "--date", "{{ prev_ds }}",
            "--source", GOOGLE_CLOUD_STORAGE_SOURCE_FILES,
            "--destination", GOOGLE_CLOUD_DATAWAREHOUSE_BUCKET,
        ]
    }
}

# Generate Dataproc cluster
cluster_generator = ClusterGenerator(
    cluster_name=DATAPROC_CLUSTER_NAME,
    project_id=GOOGLE_CLOUD_PROJECT_ID,
    zone=GOOGLE_CLOUD_ZONE,
    storage_bucker=GOOGLE_CLOUD_STORAGE_BUCKET,

    num_workers=DATAPROC_NUM_WORKERS,
    min_num_workers=DATAPROC_NUM_WORKERS,
    num_masters=DATAPROC_NUM_MASTERS,
    master_machine_type=DATAPROC_MASTER_MACHINE_TYPE,
    worker_machine_type=DATAPROC_WORKER_MACHINE_TYPE,
    master_disk_size=DATAPROC_MASTER_DISK_SIZE,
    worker_disk_size=DATAPROC_WORKER_DISK_SIZE,
    # master_disk_type=DATAPROC_MASTER_DISK_TYPE,
    # worker_disk_type=DATAPROC_MASTER_DISK_TYPE,
).make()


# initializing the default arguments
default_args = {
    'start_date': start_date,
    'retries': 3,
    'retry_delay': timedelta(hours=1)
}

with DAG(
    dag_id='dag_02_extract_gh_data',
    default_args=default_args,
    schedule='0 3 * * *',
) as dag:

    task_start = EmptyOperator(task_id='task_start', dag=dag)
    task_end = EmptyOperator(task_id='task_end', dag=dag)

    # task_create_cluster = DataprocCreateClusterOperator(
    #     task_id="task_create_cluster",
    #     dag=dag,
    #     project_id=GOOGLE_CLOUD_PROJECT_ID,
    #     cluster_config=cluster_generator,
    #     region=GOOGLE_CLOUD_REGION,
    #     cluster_name=DATAPROC_CLUSTER_NAME,
    # )

    task_pyspark_run_job = DataprocSubmitJobOperator(
        task_id="task_pyspark_run_job",
        dag=dag,
        job=dataproc_job,
        region=GOOGLE_CLOUD_REGION,
        project_id=GOOGLE_CLOUD_PROJECT_ID,
    )

    # task_delete_cluster = DataprocDeleteClusterOperator(
    #     task_id="task_delete_cluster",
    #     dag=dag,
    #     project_id=GOOGLE_CLOUD_PROJECT_ID,
    #     cluster_name=DATAPROC_CLUSTER_NAME,
    #     region=GOOGLE_CLOUD_REGION,
    # )

    task_check_bigquery = BigQueryCheckOperator(
        task_id="task_check_bigquery",
        sql="""SELECT 1""",
        use_legacy_sql=False,
        dag=dag,
        location=GOOGLE_CLOUD_REGION,
    )

    # query_staging_to_dim_users = """
    # INSERT INTO dimentional_user_table (user_id, user_name, user_url)
    # SELECT actor_id AS user_id, actor_login AS user_name, actor_url AS user_url
    # FROM `{{ GOOGLE_CLOUD_PROJECT_ID }}.{{ BIGQUERY_DATASET_ID }}.external_table_allowed_events`
    # WHERE created_at_date >= '{{ prev_ds }}' AND created_at_date < '{{ ds }}' 
    # AND actor_id NOT IN (
    #     SELECT user_id
    #     FROM `{{ GOOGLE_CLOUD_PROJECT_ID }}.{{ BIGQUERY_DATASET_ID }}.dimentional_user_table`
    # )
    # """
    # task_staging_to_dim_users = BigQueryInsertJobOperator(
    #     task_id="task_staging_to_dim_users",  
    #     configuration={
    #         "query": {
    #             "query": query_staging_to_dim_users,
    #             "useLegacySql": False
    #         }
    #     },
    #     dag=dag,
    # )

    # query_staging_to_dim_repository = """
    # INSERT INTO dimentional_repository_table (repository_id, repository_name, repository_url)
    # SELECT repository_id, repository_name, repository_url
    # FROM `{{ GOOGLE_CLOUD_PROJECT_ID }}.{{ BIGQUERY_DATASET_ID }}.external_table_allowed_events`
    # WHERE created_at_date >= '{{ prev_ds }}' AND created_at_date < '{{ ds }}' 
    # AND actor_id NOT IN (
    #     SELECT repository_id
    #     FROM `{{ GOOGLE_CLOUD_PROJECT_ID }}.{{ BIGQUERY_DATASET_ID }}.dimentional_repository_table`
    # )
    # """
    # task_staging_to_dim_repository = BigQueryInsertJobOperator(
    #     task_id="task_staging_to_dim_repository",  
    #     configuration={
    #         "query": {
    #             "query": query_staging_to_dim_repository,
    #             "useLegacySql": False
    #         }
    #     },
    #     dag=dag,
    # )

    # query_staging_to_dim_organization = """
    # INSERT INTO dimentional_organization_table (organization_id, organization_name, organization_url)
    # SELECT organization_id, organization_name, organization_url
    # FROM `{{ GOOGLE_CLOUD_PROJECT_ID }}.{{ BIGQUERY_DATASET_ID }}.external_table_allowed_events`
    # WHERE created_at_date >= '{{ prev_ds }}' AND created_at_date < '{{ ds }}' 
    # AND actor_id NOT IN (
    #     SELECT organization_id
    #     FROM `{{ GOOGLE_CLOUD_PROJECT_ID }}.{{ BIGQUERY_DATASET_ID }}.dimentional_organization_table`
    # )
    # """
    # task_staging_to_dim_organization = BigQueryInsertJobOperator(
    #     task_id="task_staging_to_dim_organization",  
    #     configuration={
    #         "query": {
    #             "query": query_staging_to_dim_organization,
    #             "useLegacySql": False
    #         }
    #     },
    #     dag=dag,
    # )



# task_start >> task_create_cluster >> task_pyspark_run_job >> task_delete_cluster >> task_check_bigquery >> task_end
task_start >>  task_pyspark_run_job >>  task_check_bigquery >> task_query_staging >> task_end

# task_start >>  task_pyspark_run_job >>  task_check_bigquery 
# task_check_bigquery >> task_staging_to_dim_users >> task_end
# task_check_bigquery >> task_staging_to_dim_repository >> task_end
# task_check_bigquery >> task_staging_to_dim_organization >> task_end