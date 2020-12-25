# AWS S3 Bucket Terraform Module

Terraform module which creates an S3 bucket with a lifecycle policy, encryption, and access control.

## Overview

Buckets are created with the following defaults:

1. Access Control:
   1. Default bucket ACL is `bucket-owner-full-control`.
   1. This is so that the IAM policy attached to the bucket are honored during cross-account writes and files don't become inaccessible.
   1. Override with `acl`.
1. Deletion:
   1. Files are not deleted by default.
   1. Override with `lifecycle_delete_days`.
   1. Enabled with `enable_delete_lifecycle`.
   1. Files in `*/tmp/*` prefixes are deteted after 14 days.
1. Encryption:
   1. AES256 encrypted.
1. Transitioning:
   1. Files are not moved to Glacier by default.
   1. Override with `lifecycle_glacier_days` to archive objects after 365 days since creation date.
   1. Enabled with `enable_glacier_lifecycle`.
1. Versioning:
   1. Objects are versioned by default.
   1. Override with `enable_versioning`.

## Inputs

| Name                              | Description                                                                                             | Type   | Default                       | Required |
| --------------------------------- | ------------------------------------------------------------------------------------------------------- | ------ | ----------------------------- | :------: |
| acl                               | Bucket Access Control List. Defaults is provided so that IAM policy attached to the bucket are honored. | string | `"bucket-owner-full-control"` |    no    |
| block_public_access               | Whether Amazon S3 should block all public access for this bucket.                                       | bool   | `true`                        |    no    |
| description                       | Bucket description to identify its purpose. Used in bucket tagging as well.                             | string |                               |   yes    |
| enable_delete_lifecycle           | Boolean to enable bucket deletion lifecycle rule.                                                       | bool   | `false`                       |    no    |
| enable_glacier_lifecycle          | Boolean to enable bucket Glacier lifecycle rule.                                                        | bool   | `false`                       |    no    |
| enable_lifecycle                  | Boolean to enable all lifecycle rules.                                                                  | bool   | `true`                        |    no    |
| enable_tmp_files_delete_lifecycle | Boolean to enable bucket deletion of tmp/\* files lifecycle rule.                                       | bool   | `true`                        |    no    |
| enable_versioning                 | Boolean to enable bucket versioning.                                                                    | bool   | `true`                        |    no    |
| name                              | Used to name the bucket and related resources. Used in bucket tagging as well.                          | string |                               |   yes    |
| noncurrent_lifecycle_delete_days  | Number of days since update date before objects are deleted.                                            | string | 365                           |    no    |
| noncurrent_lifecycle_glacier_days | Number of days since non-current objects are moved to Glacier.                                          | string | 365                           |    no    |
| lifecycle_delete_days             | Number of days since update date before objects are deleted.                                            | string | 365                           |    no    |
| lifecycle_glacier_days            | Number of days since object update date before it is moved to Glacier.                                  | string | 365                           |    no    |
| tags                              | S3 bucket tags.                                                                                         | string |                               |   yes    |

## Outputs

| Name               | Description                                     |
| ------------------ | ----------------------------------------------- |
| id                 | Bucket name.                                    |
| arn                | Bucket ARN.                                     |
| bucket_domain_name | Bucket URL in the format of ID.s3.amazonaws.com |

## Usage

### Create New Bucket

```terraform
module "s3" {
  source = "git::https://github.com/yegorski/terraform-aws-s3-bucket.git?ref=master"

  name        = "BUCKET_NAME"
  description = "Used for XYZ."

  enable_delete_lifecycle = false

  enable_glacier_lifecycle = true
  lifecycle_glacier_days   = 365

  tags = "${ merge(
    map("CUSTOM_TAG", "BUCKET_NAME"),
    var.tags
  )}"
}
```

### Import Existing Bucket

1. Add the `s3` module block as above.
1. Run: `terraform import module.s3.aws_s3_bucket.s3 BUCKET_NAME`.
1. Then, remove the previous bucket resource: `terraform state rm aws_s3_bucket.BUCKET_NAME`.
