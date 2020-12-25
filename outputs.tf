output "id" {
  value       = "${aws_s3_bucket.s3.id}"
  description = "Bucket name."
}

output "arn" {
  value       = "${aws_s3_bucket.s3.arn}"
  description = "Bucket ARN."
}

output "bucket_domain_name" {
  value       = "${aws_s3_bucket.s3.bucket_domain_name}"
  description = "Bucket URL in the format of ID.s3.amazonaws.com"
}
