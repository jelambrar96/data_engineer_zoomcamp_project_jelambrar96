# resource "google_service_account" "default" {
#     account_id   = "service-10240331"
#     display_name = "service-10240331"
#     # create_ignore_already_exists = true; 
# }


# resource "google_project_iam_binding" "custom_service_account_binding" {
#   project = var.project
#   role    = "roles/storage.objectViewer" 
#   members = [
#     "serviceAccount:${google_service_account.default.email}",
#   ]
# }


# Upload pyspark file to run pyspark Job
resource "google_storage_bucket_object" "pyspark_repo_archive" {
    name   = "dataproc_01_extract_gh_data.py"
    bucket = var.dataproc_bucket_name
    source = "../dataproc/dataproc_01_extract_gh_data.py"
}

# Create DataProc Cluster
resource "google_dataproc_cluster" "pyspark_cluster" {
    name   = "pyspark-cluster"
    region = var.region

    cluster_config {
        staging_bucket = var.dataproc_bucket_name

        master_config {
            num_instances = 1
            machine_type  = "n2-standard-2"
            # disk_config {
            #     boot_disk_size_gb = 32
            # }
        }

        worker_config {
            num_instances    = 3 # no exec free quota
            machine_type     = "n2-standard-2"
            # disk_config {
            #     boot_disk_size_gb = 32
            # }
        }

#        gce_cluster_config {
#            tags = ["foo", "bar"]
#            # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
#            service_account = google_service_account.default.email
#            service_account_scopes = [
#                "cloud-platform"
#            ]
#        }

        autoscaling_config {
            policy_uri = google_dataproc_autoscaling_policy.asp.name
        }
 
    }

}

resource "google_dataproc_autoscaling_policy" "asp" {
    policy_id = "dataproc-policy"
    location  = var.region

    worker_config {
        max_instances = 3
    }

    basic_algorithm {
        yarn_config {
            graceful_decommission_timeout = "30s"

            scale_up_factor   = 0.5
            scale_down_factor = 0.5
        }
    }
}


# Submit an example pyspark job to a dataproc cluster
# resource "google_dataproc_job" "pyspark" {
#     region       = google_dataproc_cluster.pyspark_cluster.region
#     force_delete = true
#     placement {
#         cluster_name = google_dataproc_cluster.pyspark_cluster.name
#     }
# 
#     pyspark_config {
#         main_python_file_uri = google_storage_bucket_object.pyspark_repo_archive.media_link
#         properties = {
#             "spark.logConf" = "true"
#         }
#     }
# }
