locals {
  instance_type = terraform.workspace == "prod" ? var.prod_instance_type : var.other_instance_type
}