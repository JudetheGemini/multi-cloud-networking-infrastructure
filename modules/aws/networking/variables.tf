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