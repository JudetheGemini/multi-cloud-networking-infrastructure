# The terraform.tfvars file is where you set actual
# values for your variables, separate from their definitions 
# in variables.tf. This allows you to easily change configurations
# without modifying the main Terraform code.

# # =============================================================================
# When to use:
    #  1. When you want to set environment-specific values for your variables.
    #  2. When you want to override default values defined in variables.tf.
    #  3. When you want to keep sensitive or environment-specific data out of version control.