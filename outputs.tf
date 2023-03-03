output "firstbucketname" {
  description = "First bucket name"
  value       = aws_s3_bucket.mybucket.id
}

output "secondbucketname" {
  description = "Second bucket name"
  value       = aws_s3_bucket.mysecondbucket.id
}