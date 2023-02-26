provider "aws" {
  profile = "demos"

  default_tags {
    tags = {
      Environment = "Sandbox"
      Terraform   = "True"
      Repo        = "spacelift-prep"
      Project     = "Spacelift tutorial"
    }
  }
}

resource "aws_s3_bucket" "imagebuilder-bucket" {
  bucket = thisismytestbucketforspacelift
}