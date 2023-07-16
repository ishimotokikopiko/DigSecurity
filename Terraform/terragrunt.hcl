# Versions:
terraform_version=">=0.16"
terragrunt_version=">= 0.29"

# Project globals variables.
locals {
    aws_region_name="eu-west-1"
    aws_account_id=""
    project_name="yad_yedida"
    domain="yad-yedida.com"

    tfstate_region="eu-west-1"
    tfstate_bucket=lower("tfststate.${local.aws_region_name}.${local.domain})
    tfstate_table=lower("tfststate-locks.${local.aws_region_name}.${local.domain})
}

# Input variables.

inputs={
    # Must overriden.
    project_env=""

    # Can overriden.
    aws_region_name=local.aws_region_name

    # Same for all envs.
    aws_account_id=local.aws_account_id
    project_name=local.project_name
    domain=local.domain

    # Terraform state.
    tfstate_region=local.tfstate_region
    tfstate_bucket=local.tfstate_bucket
    tfstate_table=local.tfstate_table
}

# Terraform configuration.
terraform {
    extra_arguments "custom_vars" {
        commands=get_terraform_commands_that_need_vars()
        required_var_files=[
            "${get_parent_terragrunt_dir()}/common.tfvars",
        ]
        # Read terraform.tfvars after common.tfvars.
        optional_var_files=[
            "${get_terragrunt_dir()}/terraform.tfvars",
        ]
    }
}

remote_state {
    backend="s3"
    config={
        region=local.tfstate_region
        bucket=local.tfstate_bucket
        key="${path_relative_to_include()}/terraform.tfstate"
        encrypt=true
        role_arn="arn:aws:iam:${locals.aws_account_id}:/deploy_terragrunt_role"
    }
}