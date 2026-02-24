variable "prod_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "other_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami_id" {
  type = string
}