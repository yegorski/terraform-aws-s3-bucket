variable "description" {
  type        = "string"
  description = "Bucket description to identify its purpose. Used in bucket tagging as well."
}

variable "enable_versioning" {
  type        = "string"
  description = "Boolean to enable bucket versioning."
  default     = true
}

variable "name" {
  type        = "string"
  description = "Used to name the bucket and related resources. Used in bucket tagging as well."
}

variable "tags" {
  type        = "map"
  description = "S3 bucket tags."
}

#########################
### Public Access ACL ###
#########################
variable "acl" {
  type        = "string"
  description = "Bucket Access Control List. Defaults is provided so that IAM policy attached to the bucket are honored."
  default     = "bucket-owner-full-control"
}

variable "block_public_access" {
  type        = "string"
  description = "Whether Amazon S3 should block all public access for this bucket."
  default     = true
}

######################
### All Lifecycles ###
######################
variable "enable_lifecycle" {
  type        = "string"
  description = "Boolean to enable all lifecycle rules."
  default     = true
}

#########################
### Glacier Lifecycle ###
#########################
variable "enable_glacier_lifecycle" {
  type        = "string"
  description = "Boolean to enable bucket Glacier lifecycle rule."
  default     = false
}

variable "lifecycle_glacier_days" {
  type        = "string"
  description = "Number of days since object update date before it is moved to Glacier."
  default     = 365
}

variable "noncurrent_lifecycle_glacier_days" {
  type        = "string"
  description = "Number of days since non-current objects are moved to Glacier."
  default     = 30
}

###########################
### Deletion Lifecycle  ###
###########################
variable "enable_delete_lifecycle" {
  type        = "string"
  description = "Boolean to enable bucket deletion lifecycle rule."
  default     = false
}

variable "lifecycle_delete_days" {
  type        = "string"
  description = "Number of days since update date before objects are deleted."
  default     = 365
}

variable "noncurrent_lifecycle_delete_days" {
  type        = "string"
  description = "Number of days since update date before objects are deleted."
  default     = 60
}

#############################
### Temp Files LifeCycle  ###
#############################
variable "enable_tmp_files_delete_lifecycle" {
  type        = "string"
  description = "Boolean to enable bucket deletion of tmp/* files lifecycle rule."
  default     = true
}
