# Automatic Ghost Deployment
A terraform template which will deploy ghost to AWS and proxy traffic through Cloudflare.

*Warning:* This template will deploy and EC2 instance by searching for the newest available Ubuntu 20.04 AMI in the AWS region that you're deploying. If you decide to modify the template when a newer Ubuntu AMI is available in your region the EC2 instance will be deleted and replaced with a deployment using the newer AMI. To avoid your instance being overwritten with a blank one you may want to consider hard coding the AMI ID after deployment.

## Build Guide:
Note: This requires the AWS SDK to be configured on the machine the template is deployed from and will use the 'default' profile unless otherwise specified in the root 'variables.tf' file.

1. Populate the 'variable.tf' file in the root directory with 'default' values. This will inject the appropriate values throughout the rest of the template.
2. Initialize Terraform ```terraform init```
3. Create the deployment plan ```terraform build -out myplan```
4. Run the deployment plan ```terraform apply myplan```


