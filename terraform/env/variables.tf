variable "subnets" {
  description = "the subnets used on the lambdas"

  type = list(string)
  default = ["subnet-05f6016040331f9ba", "subnet-0fbf4cc158460f80c"]
}

variable "security_group_ids" {
  description = "the security groups used in the lambdas"

  type = list(string)
  default = ["sg-08adfce114a3ccdc0"]
}

variable "lambda_role" {
  description = "This is the ARN of the execution role used by the lambdas"
  type = string
  default = "arn:aws:iam::449436368289:role/datacity-bartender-lambda-dev"
}

variable "root_path" {
  description = "the root path for the source code of the library"

  type = string
  default = "/../../"
}
