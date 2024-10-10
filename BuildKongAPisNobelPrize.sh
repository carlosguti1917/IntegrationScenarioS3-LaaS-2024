#!/bin/bash
# Create the Kong API Gateway APIs for Nobel Prize Process
# create a service for each endpoint
KONG_SERVER_ADDRESS=localhost
AWS_CAMUNDA=$addressCamunda

AWS_CAMUNDA=ec2-3-95-160-18.compute-1.amazonaws.com

CAMUNDA_ENGINE_URL=http://$AWS_CAMUNDA:8080/engine-rest 
CAMUNDA_ENGINE_MESSAGE_URL=$CAMUNDA_ENGINE_URL/message

echo "Delete the nobel prize App"
NOBEL_APP_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/consumers/NobelPrizeApp" | jq -r '.id')
ECHO 'NobelPrizeApp id = ' $NOBEL_APP_ID
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/consumers/${CAMUNDA_APP_ID}"

curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"
SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-prizenominator-service" | jq -r '.id')

echo " ##################################### \n"
echo " Creating consumer NobelPrizeApp \n"
echo " ##################################### \n"

curl -i -X POST http://${KONG_SERVER_ADDRESS}:8001/consumers/ \
  --data "username=NobelPrizeApp"
#Create the credentials for NobelPrizeApp

echo 'Creating credentials for CamundaApp'
curl -i -X POST "http://${KONG_SERVER_ADDRESS}:8001/consumers/NobelPrizeApp/oauth2" \
  --data "name=NobelPrizeApp" \
  --data "client_id=1234560" \
  --data "client_secret=4152630" \
  --data "redirect_uris[]=http://my-redirect-uri.com"

echo 'Creating fixed token for CamundaApp'
CAMUNDAAPP_CREDENTIAL_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/consumers/NobelPrizeApp/oauth2" | jq -r '.data[0].id')
curl -i -X POST "http://${KONG_SERVER_ADDRESS}:8001/oauth2_tokens" \
  --data "access_token=9123456789e0" \
  --data "token_type=bearer" \
  --data "expires_in=14400" \
  --data "credential.id=${CAMUNDAAPP_CREDENTIAL_ID}" \
  --data "authenticated_userid=1234560" \  

echo "# Creating new service camunda-prizenominator-service \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=camunda-prizenominator-service" \
--data "url=${CAMUNDA_ENGINE_URL}/process-definition/key/PrizeNominator/start"   

echo "# SendNominationForm \n"
echo "Prize Nomination \n'"
echo -e "# Deleting new route prize-nominator-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/prize-nominator-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

echo -e "#Creating new route prize-nominator-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-prizenominator-service/routes" \
--data "name=prize-nominator-route" \
--data "paths[]=/sandbox/NobelCommitteeForMedicine/v1/Nominations/SendNominationForm" \
--data "methods[]=POST"

echo " Enabling OAuth2 plugin to prize-nominator-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/prize-nominator-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-prize-nominator-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 


echo ' \n Creating new route Send Nominee Completed Form \n'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-engine-message-service/routes" \
--data "name=send-Nominee-completed-form" \
--data "paths[]=/sandbox/Nominator/v1/Nomenee/SendNomineeCompletedForm" \
--data "methods[]=POST"