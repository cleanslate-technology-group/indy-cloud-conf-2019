provider "aws" {
  version = "~> 1.55"
  region  = "us-east-2"
}

provider "tls" {
  version = "1.2"
}

provider "local" {
  version = "1.1"
}

provider "null" {
  version = "2.0"
}

terraform {
  required_version = "0.11.7"

  backend "s3" {
    bucket         = "tf-global-stream-deck-demo"
    key            = "demo/demo.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "ops-terraform-lock"
  }
}
