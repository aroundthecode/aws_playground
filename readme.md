# Terrafrom aws playground

Project to insert all AWS terrafrom experiment.

* Create a separate folder for each project (you can re-use maintf file for default aws provider and variables)
* Copy sample.env file to .env inserting your AWS credentials
* edit Makefile TERRAFORM_BIN constant to point to your terrafrom binary 
* use make passing PROJECT varialble with the same name as your project folder

## Init terraform project

```
make PROJECT=vm_import init
```

## Validate terraform project

```
make PROJECT=vm_import validate
```

## Terraform project plan

```
make PROJECT=vm_import plan
```

## Apply terraform project

WARNING: no apply confimration will be preompt!

```
make PROJECT=vm_import apply
```

## Destroy terraform resources

WARNING: no destroy confimration will be preompt!

```
make PROJECT=vm_import destoy
```

# Available projects

## eks
Full Kubernetes Eks cluster with both fargate and a single node ec2 instance.

Apply will also produce kubecondif file to be used to connect to the cluster.

**WARNING!**
```
⚠️⚠️⚠️ EKS cluster costs are outside AWS free plan! ⚠️⚠️⚠️
```

## vpc_ha

* Creates a VPC with a public and a private subnet for each abailability zone.
* Creates an autoscaling group to maintain a single worpress insance available across the 3 availability zones
* Creates an Elastic Ip and uses a Livecycle hook with a python lambta to keep it attached to the running instance upon scaling events.

## elasting_running_worpress
Retrieve current running wodpress insance and "manually" attach elastic IP to it

## lambda_api_gw

Creates an HelloWord lambra function and exposes it via Api Gateway

## vm_import

Creates a S3 backed with proper roles to be used to import AMI images from OVA Templates
## vpc_ec2_instance

Creates a private VPC with a Wordpress VM inside, configures http/https and ssh access

## vpc_ec2_instance_docker

* Creates a private VPC with a Docker-ready VM inside, configures http/https and ssh access.
* Creates a ECR Docker regisry and setup endpoints to be reachable from internal docker to pull images and execute on the VM