provider "aws" {
  region  = var.aws_region
    assume_role {
        role_arn     = "arn:aws:iam::${var.aws_account}:role/${var.aws_role}"
    }

}
