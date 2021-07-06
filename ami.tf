provider "aws" {
  region  = var.aws_region
    assume_role {
        role_arn     = "arn:aws:iam::${var.aws_account}:role/${var.aws_role}"
    }

}
resource "aws_ami_from_instance" "example" {
     name = var.instance-migration-name
     source_instance_id = var.source_instance_id
}
