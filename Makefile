MYPATH := $(shell pwd)
TF_VAR_flpath := ${MYPATH}

ifneq (,$(wildcard ./.env))
    include .env
    export
endif

TERRAFORM_BIN := terraform1011

version:
	@${TERRAFORM_BIN} version
validate:
	@${TERRAFORM_BIN} validate
plan:
	@${TERRAFORM_BIN} plan
apply:
	@${TERRAFORM_BIN} apply -auto-approve 
destroy:
	@${TERRAFORM_BIN} destroy -auto-approve 
