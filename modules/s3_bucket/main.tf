resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  acl    = var.acl

  # Enable versioning
  versioning {
    enabled = var.enable_versioning
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = var.tags
}
