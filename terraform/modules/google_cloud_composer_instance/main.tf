
resource "local_file" "env_vars" {
    content  = jsonencode({
        "GOOGLE_CLOUD_PROJECT_ID" : var.project,
        "GOOGLE_CLOUD_STORAGE_BUCKET" : var.data_warehouse_bucket_name,
        "REGION": var.region,
        "download_gh_data_cloud_function": var.cloud_fuction_link
    })
    filename = "${path.module}/env_vars.json"
}

# Create composer Environment
resource "google_composer_environment" "composer_service" {
    name   = "capstone-project-composer-service"
    project = var.project
    region = var.region

    config {

        software_config {
                airflow_config_overrides = {
                core-dags_are_paused_at_creation = "True"
                image_version = "composer-2-airflow-2"                
            }
            pypi_packages = {
                apache-airflow-providers-dbt-cloud = ""
            }
        }

        workloads_config {
            scheduler {
                cpu        = 0.5
                memory_gb  = 1.875
                storage_gb = 1
                count      = 1
            }
            web_server {
                cpu        = 0.5
                memory_gb  = 1.875
                storage_gb = 1
            }
            worker {
                cpu = 0.5
                memory_gb  = 1.875
                storage_gb = 1
                min_count  = 1
                max_count  = 3
            }
        }
    }
}

locals {
    bucket_path = google_composer_environment.composer_service.config.0.dag_gcs_prefix
    project_id  = split("/", local.bucket_path)[2]
}

resource "google_storage_bucket_object" "composer_repo_archive" {
    for_each = fileset("../composer/dags/", "*.py")

    name   = "dags/${each.key}"
    bucket = local.project_id
    source = "../composer/dags/${each.key}"
}