variable "myip" {
  type        = "string"
  description = "IP to open for bastion, defaults to open"
  default     = "0.0.0.0/0"
}

variable "ami" {
  type        = "string"
  description = "AWS AMI to use"
  default     = "ami-02bcbb802e03574ba"
}

variable "cidr" {
  type        = "string"
  description = "VPC CIDR range"
  default     = "10.0.0.0/16"
}

variable "cidr_public" {
  type        = "string"
  description = "Public Subnet CIDR range"
  default     = "10.0.0.0/24"
}

variable "enable_dns_hostnames" {
  type        = "string"
  description = "Enable DNS Hostnames"
  default     = true
}

variable "enable_dns_support" {
  type        = "string"
  description = "Enable DNS Support"
  default     = true
}

variable "region" {
  type        = "string"
  description = "region"
  default     = "us-east-2"
}

variable "azs" {
  type        = "map"
  description = "available azs by region"

  default = {
    us-east-1 = "us-east-1a,us-east-1b,us-east-1c,us-east-1d,us-east-1e"
    us-east-2 = "us-east-2a,us-east-2b,us-east-2c"
    us-west-1 = "us-west-1a,us-west-1b"
    us-west-2 = "us-west-2a,us-west-2b,us-west-2c"
  }
}

variable "public_dest_cidr" {
  type        = "string"
  description = "allowed remote destinations"
  default     = "0.0.0.0/0"
}

// Common Tags
variable "name" {
  type        = "string"
  description = "name"
  default     = "indy-cloud-conf-2019"
}

variable "env" {
  type        = "string"
  description = "environment"
  default     = "demo"
}

variable "managed" {
  type        = "string"
  description = "Terraform Version"
  default     = "Terraform v0.11.7"
}
