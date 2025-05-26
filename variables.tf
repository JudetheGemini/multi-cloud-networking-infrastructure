# =============================================================================
# GENERAL VARIABLES
# =============================================================================

variable "project_name" {
  description = "Name of the project, used for resource naming and tagging"
  type        = string
  default     = "multicloud-networking"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "owner" {
  description = "Owner of the resources for tagging purposes"
  type        = string
  default     = "devops-team"
}


# =============================================================================
# AWS VARIABLES
# =============================================================================

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-west-1"
}

variable "aws_vpc_name" {
  description = "Name for the AWS VPC"
  type        = string
  default     = "aws-vpc"
}

variable "aws_vpc_cidr" {
  description = "CIDR block for AWS VPC"
  type        = string
  default     = "10.0.0.0/16"
  
  validation {
    condition     = can(cidrhost(var.aws_vpc_cidr, 0))
    error_message = "AWS VPC CIDR must be a valid IPv4 CIDR block."
  }
}

variable "aws_availability_zones" {
  description = "List of availability zones for AWS resources"
  type        = list(string)
  default     = ["us-west-1a", "us-west-1b", "us-west-1c"]
}

variable "aws_private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "aws_public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "aws_enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "aws_single_nat_gateway" {
  description = "Use a single NAT Gateway for all private subnets (cost optimization)"
  type        = bool
  default     = true
}

variable "aws_one_nat_gateway_per_az" {
  description = "Create one NAT Gateway per availability zone (higher availability, higher cost)"
  type        = bool
  default     = false
}

variable "aws_enable_vpn_gateway" {
  description = "Enable VPN Gateway for the VPC"
  type        = bool
  default     = true
}

variable "aws_enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "aws_enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "aws_flow_log_file_format" {
  description = "File format for VPC Flow Logs"
  type        = string
  default     = "parquet"
  
  validation {
    condition     = contains(["plain-text", "parquet"], var.aws_flow_log_file_format)
    error_message = "Flow log file format must be either 'plain-text' or 'parquet'."
  }
}

variable "aws_enable_flow_logs" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = true
}

variable "aws_flow_log_destination_type" {
  description = "Destination type for VPC Flow Logs (cloud-watch-logs, s3)"
  type        = string
  default     = "s3"
  
  validation {
    condition     = contains(["cloud-watch-logs", "s3"], var.aws_flow_log_destination_type)
    error_message = "Flow log destination type must be either 'cloud-watch-logs' or 's3'."
  }
}

# =============================================================================
# AZURE VARIABLES
# =============================================================================

variable "azure_location" {
  description = "Azure region for resources"
  type        = string
  default     = "West US"
}

variable "azure_resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "rg-multicloud-networking"
}

variable "azure_vnet_name" {
  description = "Name for the Azure Virtual Network"
  type        = string
  default     = "azure-vnet"
}

variable "azure_vnet_address_space" {
  description = "Address space for Azure Virtual Network"
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "azure_public_subnet_name" {
  description = "Name for Azure public subnet"
  type        = string
  default     = "public-subnet"
}

variable "azure_public_subnet_prefix" {
  description = "Address prefix for Azure public subnet"
  type        = string
  default     = "10.1.1.0/24"
}

variable "azure_private_subnet_name" {
  description = "Name for Azure private subnet"
  type        = string
  default     = "private-subnet"
}

variable "azure_private_subnet_prefix" {
  description = "Address prefix for Azure private subnet"
  type        = string
  default     = "10.1.10.0/24"
}

variable "azure_enable_ddos_protection" {
  description = "Enable DDoS protection for Azure VNet"
  type        = bool
  default     = false
}

# =============================================================================
# SECURITY VARIABLES
# =============================================================================

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed for SSH/RDP access"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Change this for security
}

variable "allowed_ssh_cidr_blocks" {
  description = "List of CIDR blocks allowed for SSH access (port 22)"
  type        = list(string)
  default     = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

variable "allowed_rdp_cidr_blocks" {
  description = "List of CIDR blocks allowed for RDP access (port 3389)"
  type        = list(string)
  default     = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

variable "allowed_http_cidr_blocks" {
  description = "List of CIDR blocks allowed for HTTP access (port 80)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_https_cidr_blocks" {
  description = "List of CIDR blocks allowed for HTTPS access (port 443)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# =============================================================================
# TAGGING VARIABLES
# =============================================================================

variable "aws_common_tags" {
  description = "Common tags to apply to AWS resources"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}

variable "azure_common_tags" {
  description = "Common tags to apply to Azure resources"
  type        = map(string)
  default = {
    terraform   = "true"
    environment = "dev"
  }
}

# =============================================================================
# OPTIONAL FEATURES
# =============================================================================

variable "create_bastion_host" {
  description = "Create bastion host for secure access"
  type        = bool
  default     = false
}

variable "create_load_balancer" {
  description = "Create load balancer resources"
  type        = bool
  default     = false
}

variable "enable_cross_cloud_connectivity" {
  description = "Enable VPN connection between AWS and Azure"
  type        = bool
  default     = false
}

variable "enable_monitoring" {
  description = "Enable monitoring and logging features"
  type        = bool
  default     = true
}

# =============================================================================
# ADVANCED NETWORKING
# =============================================================================

variable "aws_enable_nat_instance" {
  description = "Use NAT instances instead of NAT gateways (cost optimization)"
  type        = bool
  default     = false
}

variable "aws_nat_instance_type" {
  description = "Instance type for NAT instances"
  type        = string
  default     = "t3.nano"
}

variable "azure_enable_private_endpoints" {
  description = "Enable private endpoints for Azure services"
  type        = bool
  default     = false
}

variable "aws_secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks for AWS VPC"
  type        = list(string)
  default     = []
}

# =============================================================================
# DATABASE SUBNET GROUPS (Optional)
# =============================================================================

variable "aws_database_subnets" {
  description = "List of database subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
}

variable "aws_create_database_subnet_group" {
  description = "Create database subnet group"
  type        = bool
  default     = false
}