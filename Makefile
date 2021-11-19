#current folder
MYPATH := $(shell pwd)
#point to your terraform executable path
TERRAFORM_BIN := /usr/local/bin/terraform1011
# default project folder
PROJECT := vpc_ec2_instance
TERRAFORM_PATH := ${MYPATH}/${PROJECT}
# aws account (replaced by .env file)
AWS_ACCOUNT := 123456789000

#import ENV variables
ifneq (,$(wildcard ./.env))
    include .env
    export
endif


version:
	@${TERRAFORM_BIN} version
validate:
	@${TERRAFORM_BIN} -chdir=${TERRAFORM_PATH} validate
init:
	@${TERRAFORM_BIN} -chdir=${TERRAFORM_PATH} init 
plan:
	@${TERRAFORM_BIN} -chdir=${TERRAFORM_PATH} plan 
apply:
	@${TERRAFORM_BIN} -chdir=${TERRAFORM_PATH} apply -auto-approve
destroy:
	@${TERRAFORM_BIN} -chdir=${TERRAFORM_PATH} destroy -auto-approve

docker_login:
	@aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
docker_push:
	@docker pull fntlnz/caturday:latest
	@docker tag fntlnz/caturday:latest ${AWS_ACCOUNT}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/playground:latest
	@docker push ${AWS_ACCOUNT}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/playground:latest 