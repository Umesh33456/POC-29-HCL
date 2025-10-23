resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = tls_private_key.this.public_key_openssh

  tags = {
    Name = var.key_name
  }
}

# # Save the private key locally (optional)
# resource "local_file" "private_key" {
#   content  = tls_private_key.this.private_key_pem
#   filename = "${path.module}/${var.key_name}.pem"
#   file_permission = "0400"
# }

# Store the private key in S3
resource "aws_s3_bucket_object" "private_key_s3" {
  bucket  = "terraform-poc-209"
  key     = "keys/${var.key_name}.pem"
  content = tls_private_key.this.private_key_pem
  acl     = "private"
  server_side_encryption = "AES256"
}
