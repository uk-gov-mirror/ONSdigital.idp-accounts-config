variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "The AWS region in which to deploy resources"
}

variable "allowed_regions" {
  type = list(string)
  default = [
    "eu-west-2"
  ]
  description = "A list of allowed AWS regions to use in AWS-D"
}
