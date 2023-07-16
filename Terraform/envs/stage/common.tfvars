# Project globals variables.
variable "aws_region_name" {type=string}
variable "aws_account_id" {type=string}

# TF state s3 bucket and dynamodb.
variable "tfstate_region" {type=string}
variable "tfstate_bucket" {type=string}
variable "tfstate_table" {type=string}

# Project variable.
variable "project_name" {type=string}
variable "project_env" {type=string}
variable "domain" {type=string}

# Network variables.
variable "vpc_cidr" {default=""}
variable "vpc_logs_enable"{
    type=bool
    default=false
}
variable "azs" {default=1}
variable "access_cidrs" {default={}} # access_cidrs={"mng"="10.10.0.0/16"}
variable "access_sgs" {default={}}


# Locals.
locals{
    base_tags={}
    base_name="${var.project_name}-${var.project_env}"
    base_tags_provider={
        Managed="TF"
        Project=var.project_name
        Env=var.project_env
    }
}