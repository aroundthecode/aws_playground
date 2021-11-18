#current folder
MYPATH := $(shell pwd)

#import ENV variables
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

#point to your terraform executable path
TERRAFORM_BIN := /usr/local/bin/terraform1011
PROJECT := vpc_ec2_instance
TERRAFORM_PATH := ${MYPATH}/${PROJECT}

version:
	@${TERRAFORM_BIN} version
validate:
	@${TERRAFORM_BIN} -chdir=${TERRAFORM_PATH} validate ${TERRAFORM_PATH}
init:
	@${TERRAFORM_BIN} -chdir=${TERRAFORM_PATH} init 
plan:
	@${TERRAFORM_BIN} -chdir=${TERRAFORM_PATH} plan 
apply:
	@${TERRAFORM_BIN} -chdir=${TERRAFORM_PATH} apply -auto-approve
destroy:
	@${TERRAFORM_BIN} -chdir=${TERRAFORM_PATH} destroy -auto-approve
