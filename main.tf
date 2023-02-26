provider "aws" {
  assume_role_with_web_identity {
    role_arn                = "arn:aws:iam::616506319567:role/spacelift-role"
    web_identity_token_file = "/mnt/workspace/spacelift.oidc"
  }

  default_tags {
    tags = {
      Environment = "Sandbox"
      Terraform   = "True"
      Repo        = "spacelift-prep"
      Project     = "Spacelift tutorial"
    }
  }
}

resource "aws_s3_bucket" "mybucket" {
  bucket = thisismytestbucketforspacelift
}