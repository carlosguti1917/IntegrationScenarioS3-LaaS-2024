#!/bin/bash
echo "Starting..."

sudo yum install -y docker

sudo service docker start

sudo docker login -u "carlosrobertopinheiro" -p "crp@cit!1"

sudo docker pull carlosrobertopinheiro/loyaltycard:1.0.0-SNAPSHOT

sudo docker run -d --name loyaltycard -p 8080:8080 carlosrobertopinheiro/loyaltycard:1.0.0-SNAPSHOT

echo "Finished."
