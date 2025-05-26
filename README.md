# Multi-Cloud Terraform Networking Infrastructure

This Terraform project provisions essential networking infrastructure across AWS and Azure clouds, providing a foundation for deploying applications in a multi-cloud environment.

## Architecture Overview

The project creates parallel networking infrastructure in both AWS and Azure:

### AWS Components
- **VPC** (Virtual Private Cloud) with custom CIDR block
- **Public Subnets (10.0.101.0/24, 10.0.102.0/24, 10.0.103.0/24)** across us-west-1a/b/c
- **Private Subnets (10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24)** across us-west-1a/b/c
- **Internet Gateway** for public internet access
- **Single NAT Gateway** for cost optimization (shared across all private subnets)
- **VPN Gateway** enabled for hybrid connectivity
- **VPC Flow Logs** in Parquet format for network monitoring
- **Route Tables** with appropriate routing rules
- **Security Groups** with basic ingress/egress rules
- **Network ACLs** for additional network-level security

### Azure Components
- **Virtual Network (VNet)** with custom address space
- **Public and Private Subnets** across multiple regions
- **Network Security Groups (NSGs)** with security rules
- **Route Tables** with custom routes
- **Public IP** for NAT Gateway equivalent
- **Application Gateway** (optional, for load balancing)

## Prerequisites

Before running this Terraform configuration, ensure you have:

1. **Terraform installed** (version >= 1.0)
   ```bash
   terraform --version
   ```

2. **AWS CLI configured** with appropriate credentials
   ```bash
   aws configure
   # or use environment variables:
   export AWS_ACCESS_KEY_ID="your-access-key"
   export AWS_SECRET_ACCESS_KEY="your-secret-key"
   export AWS_DEFAULT_REGION="us-west-2"
   ```

3. **Azure CLI configured** with appropriate credentials
   ```bash
   az login
   az account set --subscription "your-subscription-id"
   ```

4. **Required permissions** in both clouds:
   - AWS: EC2, VPC, IAM permissions
   - Azure: Network Contributor, Virtual Machine Contributor roles

## Project Structure

```
terraform-multicloud-networking/
├── README.md
├── main.tf                 # Main configuration file
├── variables.tf           # Variable definitions
├── outputs.tf            # Output definitions
├── terraform.tfvars      # Variable values (create this file)
├── modules/
│   ├── aws/
│   │   ├── vpc.tf        # AWS VPC resources
│   │   ├── subnets.tf    # AWS subnet resources
│   │   ├── gateways.tf   # Internet/NAT gateways
│   │   ├── security.tf   # Security groups & NACLs
│   │   └── outputs.tf    # AWS outputs
│   └── azure/
│       ├── vnet.tf       # Azure VNet resources
│       ├── subnets.tf    # Azure subnet resources
│       ├── security.tf   # NSGs and security rules
│       └── outputs.tf    # Azure outputs
└── examples/
    └── terraform.tfvars.example
```

## Configuration

### 1. Create terraform.tfvars file

Copy the example file and customize for your environment:

```bash
cp examples/terraform.tfvars.example terraform.tfvars
```

### 2. Key Variables to Configure

```hcl
# General
project_name = "my-multicloud-project"
environment  = "dev"

# AWS Configuration
aws_region = "us-west-2"
aws_vpc_cidr = "10.0.0.0/16"
aws_availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]

# Azure Configuration
azure_location = "West US 2"
azure_vnet_address_space = ["10.1.0.0/16"]
azure_resource_group_name = "rg-multicloud-networking"

# Subnet Configuration
enable_nat_gateway = true
enable_vpn_gateway = false
```

## Deployment Instructions

### 1. Initialize Terraform
```bash
terraform init
```

### 2. Plan the Deployment
```bash
terraform plan
```
Review the planned changes carefully before proceeding.

### 3. Apply the Configuration
```bash
terraform apply
```
Type `yes` when prompted to confirm the deployment.

### 4. Verify Deployment
Check the outputs to confirm successful deployment:
```bash
terraform output
```

## Key Resources Created

### AWS Resources
- **VPC**: Primary virtual network with DNS support enabled
- **Internet Gateway**: Provides internet access for public subnets
- **NAT Gateway**: Enables internet access for private subnets
- **Public Subnets**: For resources requiring direct internet access (load balancers, bastion hosts)
- **Private Subnets**: For application servers and databases
- **Route Tables**: Separate routing for public and private subnets
- **Security Groups**: 
  - Web tier (HTTP/HTTPS access)
  - Application tier (internal communication)
  - Database tier (restricted database access)

### Azure Resources
- **Resource Group**: Container for all Azure resources
- **Virtual Network**: Primary network with custom address space
- **Network Security Groups**: Traffic filtering rules
- **Public IP**: For external connectivity
- **Subnets**: Public and private network segments
- **Route Tables**: Custom routing configuration

## Networking Details

### IP Address Allocation
- **AWS VPC**: 10.0.0.0/16 (configurable)
  - Public Subnets: 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24
  - Private Subnets: 10.0.10.0/24, 10.0.20.0/24, 10.0.30.0/24
- **Azure VNet**: 10.1.0.0/16 (configurable)
  - Public Subnet: 10.1.1.0/24
  - Private Subnet: 10.1.10.0/24

### Security Configuration
- **AWS Security Groups**: Configured for web, app, and database tiers
- **Azure NSGs**: Similar security rules applied to subnet level
- **Default deny**: All unnecessary traffic blocked by default
- **SSH/RDP access**: Restricted to specific IP ranges (configure in variables)

## Outputs

After successful deployment, the following information will be displayed:

```
AWS Outputs:
- vpc_id: VPC identifier
- public_subnet_ids: List of public subnet IDs
- private_subnet_ids: List of private subnet IDs
- internet_gateway_id: Internet Gateway ID
- nat_gateway_ids: NAT Gateway IDs

Azure Outputs:
- resource_group_name: Azure Resource Group name
- vnet_id: Virtual Network ID
- subnet_ids: Map of subnet names to IDs
- nsg_ids: Network Security Group IDs
```

## Cost Optimization

- **NAT Gateways**: Can be expensive in AWS. Consider using NAT instances for development environments
- **Public IPs**: Azure charges for unused public IPs
- **Cross-region traffic**: Be mindful of data transfer costs between regions
- **Resource cleanup**: Use `terraform destroy` to remove resources when not needed

## Security Best Practices

1. **Network Segmentation**: Keep public and private subnets properly isolated
2. **Security Groups/NSGs**: Apply principle of least privilege
3. **VPN/Private Connections**: Consider VPN or private peering for sensitive workloads
4. **Network Monitoring**: Enable VPC Flow Logs (AWS) and Network Watcher (Azure)
5. **Access Control**: Use IAM roles and Azure RBAC appropriately

## Maintenance

### Regular Tasks
- Review and update security group rules
- Monitor costs and optimize NAT Gateway usage
- Update Terraform providers regularly
- Review network access logs

### Scaling
To add additional subnets or modify CIDR blocks:
1. Update variables in `terraform.tfvars`
2. Run `terraform plan` to review changes
3. Apply changes with `terraform apply`

## Troubleshooting

### Common Issues

**AWS Authentication Issues**
```bash
# Verify AWS credentials
aws sts get-caller-identity
```

**Azure Authentication Issues**
```bash
# Verify Azure login
az account show
```

**CIDR Conflicts**
Ensure AWS and Azure CIDR blocks don't overlap if you plan to connect them via VPN or peering.

**Resource Limits**
Check service quotas in both AWS and Azure consoles if resources fail to create.

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

**Warning**: This will permanently delete all networking infrastructure. Ensure no dependent resources exist before running this command.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly in a development environment
5. Submit a pull request

## Support

For issues or questions:
- Check AWS and Azure documentation
- Review Terraform provider documentation
- Open an issue in the project repository

## License

This project is licensed under the MIT License - see the LICENSE file for details.