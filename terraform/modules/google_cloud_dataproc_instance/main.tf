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
        staging_bucket = "dataproc-staging-bucket"

        master_config {
            num_instances = 1
            machine_type  = "e2-medium"
            disk_config {
                boot_disk_type    = "pd-ssd"
                boot_disk_size_gb = 30
            }
        }

        worker_config {
            num_instances    = 3
            machine_type     = "e2-medium"
            min_cpu_platform = "Intel Skylake"
            disk_config {
                boot_disk_size_gb = 30
                num_local_ssds    = 1
            }
        }

  }

}


# Submit an example pyspark job to a dataproc cluster
resource "google_dataproc_job" "pyspark" {
    region       = google_dataproc_cluster.pyspark_cluster.region
    force_delete = true
    placement {
        cluster_name = google_dataproc_cluster.pyspark_cluster.name
    }

    pyspark_config {
        main_python_file_uri = "gs://dataproc-examples-2f10d78d114f6aaec76462e3c310f31f/src/pyspark/hello-world/hello-world.py"
        properties = {
            "spark.logConf" = "true"
        }
    }
}
