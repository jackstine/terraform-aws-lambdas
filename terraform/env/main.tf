terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.48.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
    external = {
      source = "hashicorp/external"
      version = "~>2.1.0"
    }
  }

  required_version = "~> 1.0"
}

provider "aws" {
  region = "us-east-1"
}

locals {
  root_path = "${path.module}${var.root_path}"
  source_path = "${path.module}${var.root_path}/src"
  terra_root_path = "${path.module}/.."
}

data "external" "zipped_files" {
  working_dir = "${local.root_path}"
  program = ["bash", "make_zips.sh", "both"]
}

resource "aws_lambda_layer_version" "hello_world_layer" {
  layer_name="barternder_pub_test"
  filename="${local.root_path}${data.external.zipped_files.result.layer_code}"
  source_code_hash = filebase64sha256("${local.root_path}${data.external.zipped_files.result.layer_code}")
}

resource "aws_lambda_function" "lambda" {
  function_name = "hello_World_test_lambda"

  filename="${local.root_path}${data.external.zipped_files.result.lambda_code}"
  source_code_hash = filebase64sha256("${local.root_path}${data.external.zipped_files.result.lambda_code}")

  runtime = "nodejs12.x"
  handler = "lambdas/hello_world.helloWorld"
  layers = [aws_lambda_layer_version.hello_world_layer.arn]
  timeout = 10 
  memory_size = 128
  vpc_config {
    subnet_ids = var.subnets
    security_group_ids = var.security_group_ids
  }

  # source_code_hash = var.source_code_hash
  
  role = var.lambda_role
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name = "/aws/lambda/${aws_lambda_function.lambda.function_name}"

  retention_in_days = 30
}
