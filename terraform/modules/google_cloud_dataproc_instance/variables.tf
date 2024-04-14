variable dataproc_bucket_name { 
    type = string
    description = ""
}

variable project {
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