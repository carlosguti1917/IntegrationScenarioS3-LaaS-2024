#!/bin/bash
# Create the Kong API Gateway APIs for Health Care Process
# create a service for each endpoint
KONG_SERVER_ADDRESS=localhost
AWS_MOCK=$addressMSMock

echo "Delete the BankApp"
BANK_APP_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/consumers/BankApp" | jq -r '.id')
ECHO 'BankApp id = ' $HEALTHCARE_APP_ID
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/consumers/${BANK_APP_ID}"

echo " ##################################### \n"
echo " Creating consumer HealthCareApp \n"
echo " ##################################### \n"

curl -i -X POST http://${KONG_SERVER_ADDRESS}:8001/consumers/ \
  --data "username=BankApp"
#Create the credentials for HealthCareApp

echo 'Creating credentials for BankApp'
curl -i -X POST "http://${KONG_SERVER_ADDRESS}:8001/consumers/BankApp/oauth2" \
  --data "name=BankApp" \
  --data "client_id=12345620" \
  --data "client_secret=20654321" \
  --data "redirect_uris[]=http://my-redirect-uri.com"

echo 'Creating fixed token for BankApp'
BANKAPP_CREDENTIAL_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/consumers/BankApp/oauth2" | jq -r '.data[0].id')
curl -i -X POST "http://${KONG_SERVER_ADDRESS}:8001/oauth2_tokens" \
  --data "access_token=9123456789e20" \
  --data "token_type=bearer" \
  --data "expires_in=14400" \
  --data "credential.id=${BANKAPP_CREDENTIAL_ID}" \
  --data "authenticated_userid=12345620" \  

echo " ##################################### \n"
echo " Creating Services and Routes  \n"
echo " ##################################### \n"

echo "# Mock Route \n"

SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/EaminingMock-service" | jq -r '.id')
if [ -z "$SERVICE_ID" ]; then
  echo "# Creating service EaminingMock-service \n"
  curl -i -X POST \
  --url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
  --data "name=EaminingMock-service" \
  --data "url=http://${AWS_MOCK}:8080/mock"
else
  echo "# Service EaminingMock-service already exists \n"
fi

echo "# Creating service EaminingMock-service \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=EaminingMock-service" \
--data "url=http://${AWS_MOCK}:8080/mock"


echo "# PartyLifecycleManagement \n"
echo -e "# Deleting new route PartyLifecycleManagement route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/PartyLifecycleManagement-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
echo -e "#Creating new route PartyLifecycleManagement-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/EaminingMock-service/routes" \
--data "name=PartyLifecycleManagement-route" \
--data "paths[]=/BIAN-3/PartyLifecycleManagement/10.0.0/PartyLifecycleManagement" \
--data "methods[]=POST" \
--data "methods[]=GET" \
--data "methods[]=PUT" \
--data "methods[]=DELETE"
echo " Enabling OAuth2 plugin to route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/PartyLifecycleManagement-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-PartyLifecycleManagement-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 


echo "# Vdocument_service \n"
echo -e "# Deleting new route document_service route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/document_service-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
echo -e "#Creating new route document_service-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/EaminingMock-service/routes" \
--data "name=document_service-route" \
--data "paths[]=/BIAN-3/DocumentServices/2.0.0/document-services" \
--data "methods[]=POST" \
--data "methods[]=GET" \
--data "methods[]=PUT" \
--data "methods[]=DELETE"
echo " Enabling OAuth2 plugin to route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/document_service-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-document_service-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 


echo "# PartyReferenceDataDirectory \n"
echo -e "# Deleting new route PartyReferenceDataDirectory route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/PartyReferenceDataDirectory-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
echo -e "#Creating new route PartyReferenceDataDirectory-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/EaminingMock-service/routes" \
--data "name=PartyReferenceDataDirectory-route" \
--data "paths[]=/BIAN-3/PartyReferenceDataDirectory/10.0.0/PartyReferenceDataDirectory" \
--data "methods[]=POST" \
--data "methods[]=GET" \
--data "methods[]=PUT" \
--data "methods[]=DELETE"
echo " Enabling OAuth2 plugin to route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/PartyReferenceDataDirectory-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-PartyReferenceDataDirectory-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo "# LegalEntityDirectory \n"
echo -e "# Deleting new route LegalEntityDirectory route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/LegalEntityDirectory-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
echo -e "#Creating new route LegalEntityDirectory-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/EaminingMock-service/routes" \
--data "name=LegalEntityDirectory-route" \
--data "paths[]=/BIAN-3/LegalEntityDirectory/10.0.0/LegalEntityDirectory" \
--data "methods[]=POST" \
--data "methods[]=GET" \
--data "methods[]=PUT" \
--data "methods[]=DELETE"
echo " Enabling OAuth2 plugin to route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/LegalEntityDirectory-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-LegalEntityDirectory-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 


echo "# CustomerCreditRating \n"
echo -e "# Deleting new route CustomerCreditRating route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/CustomerCreditRating-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
echo -e "#Creating new route CustomerCreditRating-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/EaminingMock-service/routes" \
--data "name=CustomerCreditRating-route" \
--data "paths[]=/BIAN-3/CustomerCreditRating/10.0.0/CustomerCreditRating" \
--data "methods[]=POST" \
--data "methods[]=GET" \
--data "methods[]=PUT" \
--data "methods[]=DELETE"
echo " Enabling OAuth2 plugin to route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/CustomerCreditRating-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-CustomerCreditRating-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo "# LegalCompliance \n"
echo -e "# Deleting new route LegalCompliance route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/LegalCompliance-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
echo -e "#Creating new route LegalCompliance-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/EaminingMock-service/routes" \
--data "name=LegalCompliance-route" \
--data "paths[]=/BIAN-3/LegalCompliance/10.0.0/LegalCompliance" \
--data "methods[]=POST" \
--data "methods[]=GET" \
--data "methods[]=PUT" \
--data "methods[]=DELETE"
echo " Enabling OAuth2 plugin to route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/LegalCompliance-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-LegalCompliance-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo "# RegulatoryCompliance \n"
echo -e "# Deleting new route RegulatoryCompliance route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/RegulatoryCompliance-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
echo -e "#Creating new route RegulatoryCompliance-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/EaminingMock-service/routes" \
--data "name=RegulatoryCompliance-route" \
--data "paths[]=/BIAN-3/RegulatoryCompliance/10.0.0/RegulatoryCompliance" \
--data "methods[]=POST" \
--data "methods[]=GET" \
--data "methods[]=PUT" \
--data "methods[]=DELETE"
echo " Enabling OAuth2 plugin to route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/RegulatoryCompliance-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-RegulatoryCompliance-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo "# GuidelineCompliance \n"
echo -e "# Deleting new route GuidelineCompliance route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/GuidelineCompliance-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
echo -e "#Creating new route GuidelineCompliance-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/EaminingMock-service/routes" \
--data "name=GuidelineCompliance-route" \
--data "paths[]=/BIAN-3/GuidelineCompliance/10.0.0/GuidelineCompliance" \
--data "methods[]=POST" \
--data "methods[]=GET" \
--data "methods[]=PUT" \
--data "methods[]=DELETE"
echo " Enabling OAuth2 plugin to route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/GuidelineCompliance-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-GuidelineCompliance-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo "# CustomerCreditRating \n"
echo -e "# Deleting new route CustomerCreditRating route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/CustomerCreditRating-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
echo -e "#Creating new route CustomerCreditRating-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/EaminingMock-service/routes" \
--data "name=CustomerCreditRating-route" \
--data "paths[]=/BIAN-3/CustomerCreditRating/10.0.0/CustomerCreditRating" \
--data "methods[]=POST" \
--data "methods[]=GET" \
--data "methods[]=PUT" \
--data "methods[]=DELETE"
echo " Enabling OAuth2 plugin to route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/CustomerCreditRating-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-CustomerCreditRating-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 


echo "# CustomerBehaviorInsights \n"
echo -e "# Deleting new route CustomerBehaviorInsights route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/CustomerBehaviorInsights-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
echo -e "#Creating new route CustomerBehaviorInsights-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/EaminingMock-service/routes" \
--data "name=CustomerBehaviorInsights-route" \
--data "paths[]=/BIAN-3/CustomerBehaviorInsights/10.0.0/CustomerBehaviorInsights" \
--data "methods[]=POST" \
--data "methods[]=GET" \
--data "methods[]=PUT" \
--data "methods[]=DELETE"
echo " Enabling OAuth2 plugin to route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/CustomerBehaviorInsights-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-CustomerBehaviorInsights-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo "# RegulatoryReporting \n"
echo -e "# Deleting new route RegulatoryReporting route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/RegulatoryReporting-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
echo -e "#Creating new route RegulatoryReporting-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/EaminingMock-service/routes" \
--data "name=RegulatoryReporting-route" \
--data "paths[]=/BIAN-3/RegulatoryReporting/10.0.0/RegulatoryReporting" \
--data "methods[]=POST" \
--data "methods[]=GET" \
--data "methods[]=PUT" \
--data "methods[]=DELETE"
echo " Enabling OAuth2 plugin to route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/RegulatoryReporting-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-RegulatoryReporting-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo "# LocationDataManagement \n"
echo -e "# Deleting new route LocationDataManagement route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/LocationDataManagement-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
echo -e "#Creating new route LocationDataManagement-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/EaminingMock-service/routes" \
--data "name=LocationDataManagement-route" \
--data "paths[]=/BIAN-3/LocationDataManagement/10.0.0/LocationDataManagement" \
--data "methods[]=POST" \
--data "methods[]=GET" \
--data "methods[]=PUT" \
--data "methods[]=DELETE"
echo " Enabling OAuth2 plugin to route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/LocationDataManagement-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-LocationDataManagement-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo -e " #################### END ####################################### \n"

