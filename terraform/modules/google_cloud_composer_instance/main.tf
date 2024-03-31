# Create composer Environment
resource "google_composer_environment" "composer_service" {
  name   = "${var.project}-composer-env"
  project = var.project
  region = var.region
  
  config {

    software_config {
      airflow_config_overrides = {
        core-dags_are_paused_at_creation = "True"
      }

      pypi_packages = {
        apache-airflow-providers-dbt-cloud = ""
      }

      env_variables = {
        DATAPROC_CLUSTER_NUM_WORKERS: 1,
        DATAPROC_MASTER_DISK_SIZE: 300,
        DATAPROC_MASTER_MACHINE_TYPE: "n2-standard-4",
        DATAPROC_CLUSTER_NAME: var.dataproc_cluster_name,
        DATAPROC_CLUSTER_ZONE: var.zone,
        DATAPROC_PYTHON_SCRIPTS_PATH: "gs://${var.pyspark_repo_bucket_name}",
        GOOGLE_CLOUD_PROJECT_ID: var.project,
        GOOGLE_CLOUD_STORAGE_BUCKET: var.data_warehouse_bucket_name,
        GOOGLE_CLOUD_STORAGE_DESTINATION_FILES: "gs://${var.dataproc_cluster_name}/gh-archives/processed/",
        GOOGLE_CLOUD_STORAGE_SOURCE_FILES: "gs://${var.dataproc_cluster_name}/gh-archives/raw/{0}/*",
        REGION: var.region,
        download_gh_data_cloud_function: var.cloud_fuction_link
      }

    }

    environment_size = "ENVIRONMENT_SIZE_SMALL"

  }

}

locals {
  bucket_path = google_composer_environment.composer_service.config.0.dag_gcs_prefix
  project_id  = split("/", local.bucket_path)[2]
}

resource "google_storage_bucket_object" "pyspark_repo_archive" {
  for_each = fileset("../composer/dags/", "*.py")

  name   = "dags/${each.key}"
  bucket = local.project_id
  source = "../composer/dags/${each.key}"
}

# resource "google_storage_bucket_object" "composer_repo_archive" {
#   for_each = fileset("../composer/dags/", "*.py")
# 
#   name   = "dags/${each.key}"
#   bucket = var.composer_bucket_name
#   source = "../composer/dags/${each.key}"
# }
# 
# resource "google_project_iam_member" "service_agent_role" {
#   provider = google-beta
#   project =  var.project
#   member = "serviceAccount:service-${var.project_number}@cloudcomposer-accounts.iam.gserviceaccount.com"
#   role = "roles/composer.ServiceAgentV2Ext"
# }
