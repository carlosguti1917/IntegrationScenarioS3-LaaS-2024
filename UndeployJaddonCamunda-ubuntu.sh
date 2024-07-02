#!/bin/bash


source ./access.sh

# #Terraform - Quarkus purchase
cd Quarkus-Terraform/jaddon-camunda
terraform destroy -auto-approve
cd ../..