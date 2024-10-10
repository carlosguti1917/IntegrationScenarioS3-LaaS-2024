#!/bin/bash

source ./access.sh

# # #Terraform - Mock
cd Quarkus-Terraform/mock
terraform init
terraform apply -auto-approve
cd ../..


#echo Quarkus - 
cd Quarkus-Terraform/mock
#terraform state show 'aws_instance.exampleDeployQuarkus' |grep public_dns
echo "MICROSERVICE mock IS AVAILABLE HERE:"
addressMSMock="$(terraform state show aws_instance.exampleDeployQuarkus |grep public_dns | sed "s/public_dns//g" | sed "s/=//g" | sed "s/\"//g" |sed "s/ //g" | sed "s/$esc\[[0-9;]*m//g" )"
echo "http://"$addressMSMock":8080/mock"
echo
cd ../..

#. ./ClearKongAPIs.sh

. ./BuildKongAPIsBIAN.sh
