# =============================================================================
# TERRAFORM CONFIGURATION
# =============================================================================

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# =============================================================================
# PROVIDER CONFIGURATION
# =============================================================================

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = var.aws_common_tags
  }
}

provider "azurerm" {
  features {}
}

# =============================================================================
# DATA SOURCES
# =============================================================================

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

# =============================================================================
# LOCAL VALUES
# =============================================================================

locals {
  # Common naming convention
  name_prefix = "${var.project_name}-${var.environment}"
  
  # AWS availability zones (use data source or variable)
  aws_azs = length(var.aws_availability_zones) > 0 ? var.aws_availability_zones : slice(data.aws_avavar.aws_availability_zones.available.names, 0, 3)
  
  # Common tags for all resources
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner
  }
}

# =============================================================================
# AWS NETWORKING MODULE
# =============================================================================

module "aws_networking" {
  source = "./modules/aws/networking"
  
  # Pass variables to the module
  aws_vpc_name               = "${local.name_prefix}-vpc"
  aws_vpc_cidr              = var.aws_vpc_cidr
  aws_availability_zones    = local.aws_azs
  aws_private_subnets       = var.aws_private_subnets
  aws_public_subnets        = var.aws_public_subnets
  
  # Gateway configuration
  aws_enable_nat_gateway     = var.aws_enable_nat_gateway
  aws_single_nat_gateway     = var.aws_single_nat_gateway
  aws_one_nat_gateway_per_az = var.aws_one_nat_gateway_per_az
  aws_enable_vpn_gateway     = var.aws_enable_vpn_gateway
  
  # DNS configuration
  aws_enable_dns_support    = var.aws_enable_dns_support
  aws_enable_dns_hostnames  = var.aws_enable_dns_hostnames
  
  # Flow logs configuration
  aws_enable_flow_logs           = var.aws_enable_flow_logs
  aws_flow_log_file_format      = var.aws_flow_log_file_format
  aws_flow_log_destination_type = var.aws_flow_log_destination_type
  
  # Tagging
  environment     = var.environment
}

# =============================================================================
# AZURE NETWORKING MODULE (Optional - for future implementation)
# =============================================================================

# module "azure_networking" {
#   source = "./modules/azure-networking"
#   
#   # Azure configuration
#   azure_resource_group_name = "${local.name_prefix}-rg"
#   azure_location           = var.azure_location
#   azure_vnet_name          = "${local.name_prefix}-vnet"
#   azure_vnet_address_space = var.azure_vnet_address_space
#   
#   # Subnet configuration
#   azure_public_subnet_name    = var.azure_public_subnet_name
#   azure_public_subnet_prefix  = var.azure_public_subnet_prefix
#   azure_private_subnet_name   = var.azure_private_subnet_name
#   azure_private_subnet_prefix = var.azure_private_subnet_prefix
#   
#   # Tagging
#   azure_common_tags = merge(local.common_tags, var.azure_common_tags)
#   environment       = var.environment
# }

# =============================================================================
# ADDITIONAL AWS RESOURCES (Optional)
# =============================================================================

# Example: Additional security group that uses the VPC from the module
# resource "aws_security_group" "additional_sg" {
#   count = var.create_bastion_host ? 1 : 0
  
#   name_prefix = "${local.name_prefix}-bastion"
#   vpc_id      = module.aws_networking.vpc_id
#   description = "Security group for bastion host"
  
#   ingress {
#     description = "SSH from allowed CIDRs"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = var.allowed_ssh_cidr_blocks
#   }
  
#   egress {
#     description = "All outbound traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
  
#   tags = merge(local.common_tags, {
#     Name = "${local.name_prefix}-bastion-sg"
#   })
# }

# =============================================================================
# CROSS-CLOUD CONNECTIVITY (Optional)
# =============================================================================

# Example: VPN connection between AWS and Azure (when both modules are active)
# resource "aws_customer_gateway" "azure_connection" {
#   count      = var.enable_cross_cloud_connectivity ? 1 : 0
#   bgp_asn    = 65000
#   ip_address = module.azure_networking.public_ip_address
#   type       = "ipsec.1"
#   
#   tags = merge(local.common_tags, {
#     Name = "${local.name_prefix}-azure-cgw"
#   })
# }