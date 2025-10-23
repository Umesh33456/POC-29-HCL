output "key_name" {
  description = "The name of the created key pair"
  value       = aws_key_pair.this.key_name
}

# output "private_key_path" {
#   description = "Path of the private key file"
#   value       = local_file.private_key.filename
# }

output "private_key_s3_path" {
  value = aws_s3_bucket_object.private_key_s3.key
}