#!/bin/bash

echo "deploying jaddon-camunda..."
source ./access.sh

# # #Terraform - Quarkus Micro services changing the configuration of the DB connection, recompiling and packaging
# cd microservices/projeto-jaddon-camunda/src/main/resources
# cd ../../..
# ./mvnw clean package
# cd ../..

cd Quarkus-Terraform/jaddon-camunda
terraform init
terraform apply -auto-approve
# cd ../..

##echo Quarkus - 
# cd Quarkus-Terraform/Purchase
##terraform state show 'aws_instance.exampleDeployQuarkus' |grep public_dns
echo "MICROSERVICE jaddon-camunda IS AVAILABLE HERE:"
addressMS="$(terraform state show aws_instance.exampleDeployJaddonCamunda |grep public_dns | sed "s/public_dns//g" | sed "s/=//g" | sed "s/\"//g" |sed "s/ //g" | sed "s/$esc\[[0-9;]*m//g" )"
echo "http://"$addressMS":8080/"
echo
# cd ..

