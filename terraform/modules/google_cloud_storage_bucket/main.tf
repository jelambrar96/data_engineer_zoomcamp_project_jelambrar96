# google_storage_bucket terraform documentation
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket


resource "google_storage_bucket" "general_purpose_bucket" {
    name = "${var.project}-general-purpose-bucket"
    location = var.region
    public_access_prevention = "enforced"
    force_destroy = true
}

resource "google_storage_bucket_object" "raw_folder" {
  name = "raw/"
  content = "raw data forlder."
  bucket = "${google_storage_bucket.general_purpose_bucket.name}"
}

resource "google_storage_bucket_object" "parquet_folder" {
  name = "parquet/"
  content = "parquet data forlder."
  bucket = "${google_storage_bucket.general_purpose_bucket.name}"
}

# ------------------------------------------------------------------------

resource "google_storage_bucket" "data_warehouse_bucket" {
    name  = "${var.project}-data-warehouse-bucket"
    location = var.region
    public_access_prevention = "enforced"
    force_destroy = true
}

# ------------------------------------------------------------------------

resource "google_storage_bucket" "dataproc_bucket" {
    name = "${var.project}-dataproc-bucket"
    location = var.region
    public_access_prevention = "enforced"
    force_destroy = true
}

# ------------------------------------------------------------------------

resource "google_storage_bucket" "composer_bucket" {
    name = "${var.project}-composer-bucket"
    location = var.region
    public_access_prevention = "enforced"
    force_destroy = true
}
