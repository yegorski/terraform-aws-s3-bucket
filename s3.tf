resource "aws_s3_bucket" "s3" {
  bucket = "${var.name}"
  acl    = "${var.acl}"

  versioning {
    enabled = "${var.enable_versioning}"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "${var.name}-glacier-lifecycle"
    enabled = "${var.enable_lifecycle && var.enable_glacier_lifecycle}"

    transition {
      days          = "${var.lifecycle_glacier_days}"
      storage_class = "GLACIER"
    }

    noncurrent_version_transition {
      days          = "${var.noncurrent_lifecycle_glacier_days}"
      storage_class = "GLACIER"
    }
  }

  lifecycle_rule {
    id      = "${var.name}-deletion-lifecycle"
    enabled = "${var.enable_lifecycle && var.enable_delete_lifecycle}"

    expiration {
      days = "${var.lifecycle_delete_days}"
    }

    noncurrent_version_expiration {
      days = "${var.noncurrent_lifecycle_delete_days}"
    }
  }

  lifecycle_rule {
    id      = "${var.name}-lifecycle-tmp"
    enabled = "${var.enable_lifecycle && var.enable_tmp_files_delete_lifecycle}"
    prefix  = "*/tmp/*"

    expiration {
      days = 14
    }

    noncurrent_version_expiration {
      days = 14
    }
  }

  lifecycle_rule {
    id      = "incomplete_multipart_upload_lifecycle"
    enabled = true

    abort_incomplete_multipart_upload_days = 30

    expiration {
      days = 0
    }
  }

  tags = "${merge(
    map("Name", "${var.name}"),
    map("description", "${var.description}"
  ), var.tags)}"
}

resource "aws_s3_bucket_public_access_block" "s3" {
  count = "${var.block_public_access ? 1 : 0}"

  bucket = "${ aws_s3_bucket.s3.id }"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
