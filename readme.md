# Terrafrom aws playground

Project to insert all AWS terrafrom experiment.

* Create a separate folder for each project (you can re-use maintf file for default aws provider and variables)
* Copy sample.env file to .env inserting your AWS credentials
* edit Makefile TERRAFORM_BIN constant to point to your terrafrom binary 
* use make passing PROJECT varialble with the same name as your project folder

## Init terraform project

```
make make PROJECT=vm_import init   
```

## Validate terraform project

```
make make PROJECT=vm_import validate   
```

## Terraform project plan

```
make make PROJECT=vm_import plan   
```

## Apply terraform project

WARNING: no apply confimration will be preompt!

```
make make PROJECT=vm_import apply   
```

## Destroy terraform resources

WARNING: no deatroy confimration will be preompt!

```
make make PROJECT=vm_import destoy   
```