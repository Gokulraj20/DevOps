# Define variables
variable "vpc_name" {
    type = string
    description = "Name of vpc"
}

variable "cidr_block" {
    type = string
    description = "Cidr block for vpc"
}

variable "availability_zones" {
    type = list(string)
    description = "AZs"
}
