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

WARNING: no deatroy confimration will be preompt!

```
make PROJECT=vm_import destoy
```

# Available projects

## vm_import

Creates a S3 backed with proper roles to be used to import AMI images from OVA Templates
## vpc_ec2_instance

Creates a private VPC with a Wordpress VM inside, configures http/https and ssh access

## vpc_ec2_instance_docker

Creates a private VPC with a Docker-ready VM inside, configures http/https and ssh access.
Creates a ECR Docker regisry and setup endpoints to be reachable from internal docker to pull images and execute on the VM