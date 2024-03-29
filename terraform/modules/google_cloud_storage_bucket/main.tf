# google_storage_bucket terraform documentation
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket


resource "google_storage_bucket" "general_purpose_bucket" {
    name = "${var.project}-general-purpose-bucket"
    location = var.region
    public_access_prevention = "enforced"
    force_destroy = true
}

resource "google_storage_bucket" "data_warehouse_bucket" {
    name  = "${var.project}-data-warehouse-bucket"
    location = var.region
    public_access_prevention = "enforced"
    force_destroy = true
}

resource "google_storage_bucket" "dataproc_bucket" {
    name = "${var.project}-dataproc-bucket"
    location = var.region
    public_access_prevention = "enforced"
    force_destroy = true
}

