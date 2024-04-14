variable  cloud_fuction_link {
    description = ""
    type = string
}

variable composer_bucket_name {
    description = ""
    type = string    
}

variable  dataproc_cluster_name {
    description = ""
    type = string    
}

variable "dataproc_master_disk_type" {
    description = ""
    type = string
}

variable "dataproc_worker_disk_type" {
    description = ""
    type = string
}

variable "dataproc_master_machine_type" {
    description = ""
    type = string
}

variable "dataproc_worker_machine_type" {
    description = ""
    type = string
}

variable dataproc_num_masters {
    description = ""
    type = number
}

variable dataproc_num_workers {
    description = ""
    type = number
}

variable  data_lake_bucket_name {
    description = ""
    type = string
}

variable  data_warehouse_bucket_name {
    description = ""
    type = string
}

variable project {
    description = ""
    type = string
}

variable pyspark_repo_bucket_name {
    description = ""
    type = string    
}

variable region {
    default = "us-central1"
    description = ""
    type = string
}

variable zone {
    default = "us-central1-a"
    description = ""
    type = string
}


