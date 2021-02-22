# Automatic Ghost Deployment
A terraform template which will deploy ghost to AWS and proxy traffic through Cloudflare.

## Build Guide:
Note: This requires the AWS SDK to be configured on the machine the template is deployed from and will use the 'default' profile unless otherwise specified in the root 'variables.tf' file.

1. Populate the 'variable.tf' file in the root directory with 'default' values. This will inject the appropriate values throughout the rest of the template.
2. Initialize Terraform ```terraform init```
3. Create the deployment plan ```terraform build -out myplan```
4. Run the deployment plan ```terraform apply myplan```

