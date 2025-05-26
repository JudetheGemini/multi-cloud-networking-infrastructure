# =============================================================================
# AWS NETWORKING OUTPUTS
# =============================================================================

output "aws_vpc_id" {
  description = "ID of the AWS VPC"
  value       = module.aws_networking.vpc_id
}

output "aws_vpc_cidr_block" {
  description = "CIDR block of the AWS VPC"
  value       = module.aws_networking.vpc_cidr_block
}

output "aws_vpc_arn" {
  description = "ARN of the AWS VPC"
  value       = module.aws_networking.vpc_arn
}

output "aws_private_subnet_ids" {
  description = "List of private subnet IDs in AWS"
  value       = module.aws_networking.private_subnets
}

output "aws_public_subnet_ids" {
  description = "List of public subnet IDs in AWS"
  value       = module.aws_networking.public_subnets
}

output "aws_private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks in AWS"
  value       = module.aws_networking.private_subnets_cidr_blocks
}

output "aws_public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks in AWS"
  value       = module.aws_networking.public_subnets_cidr_blocks
}

output "aws_internet_gateway_id" {
  description = "ID of the AWS Internet Gateway"
  value       = module.aws_networking.internet_gateway_id
}

output "aws_nat_gateway_ids" {
  description = "List of NAT Gateway IDs in AWS"
  value       = module.aws_networking.nat_ids
}

output "aws_nat_public_ips" {
  description = "List of public IPs for NAT Gateways in AWS"
  value       = module.aws_networking.nat_public_ips
}

output "aws_vpn_gateway_id" {
  description = "ID of the AWS VPN Gateway"
  value       = module.aws_networking.vpn_gateway_id
}

output "aws_default_security_group_id" {
  description = "ID of the default security group in AWS VPC"
  value       = module.aws_networking.vpc_default_security_group_id
}

output "aws_route_table_ids" {
  description = "AWS route table information"
  value = {
    private = module.aws_networking.private_route_table_ids
    public  = module.aws_networking.public_route_table_ids
  }
}

# =============================================================================
# AZURE NETWORKING OUTPUTS (When Azure module is implemented)
# =============================================================================

# output "azure_resource_group_name" {
#   description = "Name of the Azure Resource Group"
#   value       = module.azure_networking.resource_group_name
# }

# output "azure_vnet_id" {
#   description = "ID of the Azure Virtual Network"
#   value       = module.azure_networking.vnet_id
# }

# output "azure_subnet_ids" {
#   description = "Map of Azure subnet names to IDs"
#   value       = module.azure_networking.subnet_ids
# }

# =============================================================================
# COMBINED MULTI-CLOUD OUTPUTS
# =============================================================================

output "networking_summary" {
  description = "Summary of all networking resources across clouds"
  value = {
    aws = {
      vpc_id              = module.aws_networking.vpc_id
      vpc_cidr           = module.aws_networking.vpc_cidr_block
      availability_zones = module.aws_networking.azs
      private_subnets    = module.aws_networking.private_subnets
      public_subnets     = module.aws_networking.public_subnets
      nat_gateways       = module.aws_networking.nat_ids
      vpn_gateway        = module.aws_networking.vpn_gateway_id
    }
    # azure = {
    #   resource_group = module.azure_networking.resource_group_name
    #   vnet_id       = module.azure_networking.vnet_id
    #   subnets       = module.azure_networking.subnet_ids
    # }
  }
}

# =============================================================================
# DEPLOYMENT INFORMATION
# =============================================================================

output "deployment_info" {
  description = "Information about the deployment"
  value = {
    project_name     = var.project_name
    environment      = var.environment
    aws_region       = var.aws_region
    # azure_location   = var.azure_location
    deployment_time  = timestamp()
    terraform_workspace = terraform.workspace
  }
}

# =============================================================================
# CONNECTION INFORMATION (For applications)
# =============================================================================

output "connection_info" {
  description = "Connection information for applications"
  value = {
    aws_vpc_info = module.aws_networking.vpc_info
    # Add Azure info when implemented
  }
  sensitive = false
}