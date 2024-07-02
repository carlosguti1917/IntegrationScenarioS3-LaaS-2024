#!/bin/bash
echo "Starting..."

sudo yum update -y

sudo yum install -y docker

sudo service docker start

# sudo docker pull camunda/camunda-bpm-platform:latest

# sudo docker run -d --name camunda -p 8080:8080 camunda/camunda-bpm-platform:latest

# sudo docker pull carlosrobertopinheiro/project-jaddon-camunda:1.0.0-SNAPSHOT

# sudo docker run -d --name jaddon-camunda -p 8080:8080 carlosrobertopinheiro/project-jaddon-camunda:1.0.0-SNAPSHOT

sudo docker pull carlosrobertopinheiro/camunda-bmp-run-extended:1.0.0

sudo docker run -d --name camunda -p 8080:8080 carlosrobertopinheiro/camunda-bmp-run-extended:1.0.0

echo "Finished."
