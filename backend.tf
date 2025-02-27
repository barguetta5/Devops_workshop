terraform {
    backend "s3" {
      bucket = "barg-bucket2"
      key = "tf/statFile"
      region = "eu-west-1"
    }
}