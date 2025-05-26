module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.aws_vpc_name
  cidr = var.aws_vpc_cidr

  azs             = var.aws_azs
  private_subnets = var.aws_private_subnets
  public_subnets  = var.aws_public_subnets

  enable_nat_gateway     = var.aws_enable_nat_gateway
  single_nat_gateway     = var.aws_single_nat_gateway
  one_nat_gateway_per_az = var.aws_one_nat_gateway_per_az
  enable_vpn_gateway     = var.aws_enable_vpn_gateway
  enable_dns_support     = var.aws_enable_dns_support


  enable_flow_log           = var.aws_enable_flow_logs
  flow_log_file_format      = var.aws_flow_log_file_format
  flow_log_destination_type = var.aws_flow_log_destination_type

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}
