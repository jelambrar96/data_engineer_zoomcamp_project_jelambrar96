
output "dataproc_cluster_name" {
    value = google_dataproc_cluster.pyspark_cluster.name
}

output "dataproc_master_disk_type" {
    value = google_dataproc_cluster.pyspark_cluster.cluster_config.0.master_config.0.disk_config.0.boot_disk_type
}

output "dataproc_worker_disk_type" {
    value = google_dataproc_cluster.pyspark_cluster.cluster_config.0.worker_config.0.disk_config.0.boot_disk_type
}

output "dataproc_master_machine_type" {
    value = google_dataproc_cluster.pyspark_cluster.cluster_config.0.master_config.0.machine_type
}

output "dataproc_worker_machine_type" {
    value = google_dataproc_cluster.pyspark_cluster.cluster_config.0.worker_config.0.machine_type
}

output "dataproc_num_masters_instances" {
    value = google_dataproc_cluster.pyspark_cluster.cluster_config.0.master_config.0.num_instances
}

output "dataproc_num_workers_instances" {
    value = google_dataproc_cluster.pyspark_cluster.cluster_config.0.worker_config.0.num_instances
}

# Check out current state of the jobs
# output "spark_status" {
#     value = google_dataproc_job.pyspark.status
#     value = google_dataproc_job.spark.status[0].state
# }
# 
# output "pyspark_status" {
#     value = google_dataproc_job.pyspark.status
#     value = google_dataproc_job.pyspark.status[0].state
# }
