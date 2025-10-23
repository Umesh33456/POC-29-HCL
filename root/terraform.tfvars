

region          = "us-east-1"
project_name    = "POC 29"
vpc_cidr        = "10.1.0.0/16"
pub_sub_1a_cidr = "10.1.1.0/24"
pri_sub_3a_cidr = "10.1.2.0/24"

key_name      = "web_key"
vpc_id        = "vpc-0ec05ed244c01d6a4"
sg_name       = "jenkins_sg"
ami_id        = "ami-052064a798f08f0d3"
instance_type = "t2.micro"
instance_name = "POC_29_server"