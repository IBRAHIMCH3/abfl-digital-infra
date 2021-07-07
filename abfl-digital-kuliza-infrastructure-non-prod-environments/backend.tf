terraform {
  backend "s3" {
    # S3 Bucket name
    
    bucket          = "abflibrahim"
    #key            = "global/ec2/terraform.tfstate"
    region          = "ap-southeast-1"
    
    #DynamoDB table name!
    
    #dynamodb_table = "ent-tf-statelock"
    #encrypt        = true
  }
}
