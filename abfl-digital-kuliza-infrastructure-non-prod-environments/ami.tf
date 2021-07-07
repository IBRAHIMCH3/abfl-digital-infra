
resource "aws_ami_from_instance" "example" {
     name = var.instance-migration-name
     source_instance_id = var.source_instance_id
}
