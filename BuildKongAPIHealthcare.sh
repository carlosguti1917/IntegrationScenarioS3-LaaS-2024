#!/bin/bash
# Create the Kong API Gateway APIs for Health Care Process
# create a service for each endpoint
KONG_SERVER_ADDRESS=localhost
AWS_CAMUNDA=$addressCamunda
AWS_MOCK=$addressMSMock


#AWS_CAMUNDA=ec2-54-162-89-229.compute-1.amazonaws.com
#AWS_MOCK=ec2-54-92-171-102.compute-1.amazonaws.com

CAMUNDA_ENGINE_URL=http://$AWS_CAMUNDA:8080/engine-rest 
CAMUNDA_ENGINE_MESSAGE_URL=$CAMUNDA_ENGINE_URL/message

echo "Delete the HealthCareApp"
HEALTHCARE_APP_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/consumers/HealthCareApp" | jq -r '.id')
ECHO 'HealthCareApp id = ' $HEALTHCARE_APP_ID
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/consumers/${HEALTHCARE_APP_ID}"

echo " ##################################### \n"
echo " Creating consumer HealthCareApp \n"
echo " ##################################### \n"

echo "Delete the HealthCareApp"
CAMUNDA_APP_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/consumers/HealthCareApp" | jq -r '.id')
ECHO 'HealthCareApp id = ' $CAMUNDA_APP_ID
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/consumers/${CAMUNDA_APP_ID}"

curl -i -X POST http://${KONG_SERVER_ADDRESS}:8001/consumers/ \
  --data "username=HealthCareApp"
#Create the credentials for HealthCareApp

echo 'Creating credentials for HealthCareApp'
curl -i -X POST "http://${KONG_SERVER_ADDRESS}:8001/consumers/HealthCareApp/oauth2" \
  --data "name=HealthCareApp" \
  --data "client_id=1234562" \
  --data "client_secret=4152632" \
  --data "redirect_uris[]=http://my-redirect-uri.com"

echo 'Creating fixed token for HealthCareApp'
CAMUNDAAPP_CREDENTIAL_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/consumers/HealthCareApp/oauth2" | jq -r '.data[0].id')
curl -i -X POST "http://${KONG_SERVER_ADDRESS}:8001/oauth2_tokens" \
  --data "access_token=9123456789e1" \
  --data "token_type=bearer" \
  --data "expires_in=14400" \
  --data "credential.id=${CAMUNDAAPP_CREDENTIAL_ID}" \
  --data "authenticated_userid=1234561" \  

echo " ##################################### \n"
echo " Creating Services  \n"
echo " ##################################### \n"

echo "# Mock Route \n"

SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/EaminingMock-service" | jq -r '.id')
echo "# Deleting service EaminingMockservice \n"
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"

echo "# Creating service EaminingMock-service \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=EaminingMock-service" \
--data "url=http://${AWS_MOCK}:8080/mock"

echo " ##################################### \n"
echo "# SendInformation Route \n"
echo " ##################################### \n"

echo -e "# Deleting new route applicant-sendinformation-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/applicant-sendinformation-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-health-insuance-service" | jq -r '.id')
echo "# Deleting service camunda-health-insuance-service \n"
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"

echo "# Creating service camunda-health-insuance-service \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=camunda-health-insuance-service" \
--data "url=${CAMUNDA_ENGINE_URL}/process-definition/key/Process_Insurance-TO-BE-2/start"   

echo -e "#Creating new route applicant-sendinformation-route\n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-health-insuance-service/routes" \
--data "name=applicant-sendinformation-route" \
--data "paths[]=/sandbox/Process_Application/v1/Customer/SendInformation" \
--data "methods[]=POST"

echo " Enabling OAuth2 plugin to applicant-sendinformation-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/applicant-sendinformation-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=applicant-sendinformation-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo " ##################################### \n"
echo "# AssessApplication Route \n"
echo " ##################################### \n"

echo -e "# Deleting new route insuance-assessapplication-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/insuance-assessapplication-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-health-assessapplication-service" | jq -r '.id')
echo "# Deleting service camunda-health-assessapplication-service \n"
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"

echo "# Creating service camunda-health-assessapplication-service \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=camunda-health-assessapplication-service" \
--data "url=${CAMUNDA_ENGINE_URL}/decision-definition/key/Decision_09aokyw/evaluate"

echo -e "#Creating new route applicant-sendinformation-route\n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-health-assessapplication-service/routes" \
--data "name=insuance-assessapplication-route" \
--data "paths[]=/sandbox/Process_Insurance/v1/Consultant/AssessApplication" \
--data "methods[]=POST"

echo -e " # Enabling OAuth2 plugin to insuance-assessapplication-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/insuance-assessapplication-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=ainsuance-assessapplication-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo " ##################################### \n"
echo "# SaveProcesStatus Route \n"
echo " ##################################### \n"

echo -e "# Deleting new route Applicant-SaveProcesStatus-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/Applicant-SaveProcesStatus-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

echo -e "# Creating new route Applicant-SaveProcesStatus-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/EaminingMock-service/routes" \
--data "name=Applicant-SaveProcesStatus-route" \
--data "paths[]=/sandbox/Process_Insurance/v1/Consultant/SaveProcessStatus" \
--data "methods[]=POST"

echo -e " # Enabling OAuth2 plugin to insuance-assessapplication-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/Applicant-SaveProcesStatus-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-Applicant-SaveProcesStatus-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo " ##################################### \n"
echo "# UpdateProcesStatus Route \n"
echo " ##################################### \n"

echo -e "# Deleting new route Insuance-UpdateProcesStatus-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/Insuance-UpdateProcesStatus-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

echo -e "#Creating new route Insuance-UpdateProcesStatus-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/EaminingMock-service/routes" \
--data "name=Insuance-UpdateProcesStatus-route" \
--data "paths[]=/sandbox/Process_Insurance/v1/Consultant/UpdateProcesStatus" \
--data "methods[]=POST"

echo -e " # Enabling OAuth2 plugin to insuance-assessapplication-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/Insuance-UpdateProcesStatus-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-Insuance-UpdateProcesStatus-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo " ##################################### \n"
echo "# Insuance-InformAboutAcceptance-route \n"
echo " ##################################### \n"

echo -e "# Deleting new route Insuance-InformAboutAcceptance-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/Insuance-InformAboutAcceptance-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-health-insuance-InformAboutAcceptance-service" | jq -r '.id')
echo "# Deleting service camunda-health-insuance-InformAboutAcceptance-service \n"
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"

echo "# Creating service camunda-health-insuance-InformAboutAcceptance-service \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=camunda-health-insuance-InformAboutAcceptance-service" \
--data "url=${CAMUNDA_ENGINE_MESSAGE_URL}"  

echo -e "#Creating new route Insuance-InformAboutAcceptance-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-health-insuance-InformAboutAcceptance-service/routes" \
--data "name=Insuance-InformAboutAcceptance-route" \
--data "paths[]=/sandbox/Process_Insurance/v1/Consultant/InformAboutAcceptance" \
--data "methods[]=POST"

echo " Enabling OAuth2 plugin to Insuance-InformAboutAcceptance-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/Insuance-InformAboutAcceptance-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-Insuance-InformAboutAcceptance-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo " ##################################### \n"
echo "# Insuance-InformAboutRejection-route \n"
echo " ##################################### \n"

echo -e "# Deleting new route Insuance-InformAboutRejection-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/Insuance-InformAboutRejection-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-health-insuance-InformAboutRejection-service" | jq -r '.id')
echo "# Deleting service camunda-health-insuance-InformAboutRejection-service \n"
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"

echo "# Creating service camunda-health-insuance-InformAboutRejection-service \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=camunda-health-insuance-InformAboutRejection-service" \
--data "url=${CAMUNDA_ENGINE_MESSAGE_URL}"  

echo -e "#Creating new route Insuance-InformAboutRejection-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-health-insuance-InformAboutRejection-service/routes" \
--data "name=Insuance-InformAboutRejection-route" \
--data "paths[]=/sandbox/Process_Insurance/v1/Consultant/InformAboutRejection" \
--data "methods[]=POST"

echo " Enabling OAuth2 plugin to Insuance-InformAboutRejection-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/Insuance-InformAboutRejection-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-Insuance-InformAboutRejection-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo " ##################################### \n"
echo "# Insuance-InformAboutOffer-route \n"
echo " ##################################### \n"

echo -e "# Deleting new route Insuance-InformAboutOffer-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/Insuance-InformAboutOffer-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-health-insuance-InformAboutOffer-service" | jq -r '.id')
echo "# Deleting service camunda-health-insuance-InformAboutOffer-service \n"
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"

echo "# Creating service camunda-health-insuance-InformAboutOffer-service \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=camunda-health-insuance-InformAboutOffer-service" \
--data "url=${CAMUNDA_ENGINE_MESSAGE_URL}"  

echo -e "#Creating new route Insuance-InformAboutOffer-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-health-insuance-InformAboutOffer-service/routes" \
--data "name=Insuance-InformAboutOffer-route" \
--data "paths[]=/sandbox/Process_Insurance/v1/Consultant/InformAboutOffer" \
--data "methods[]=POST"

echo " Enabling OAuth2 plugin to Insuance-InformAboutOffer-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/Insuance-InformAboutOffer-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-Insuance-InformAboutOffer-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo " ##################################### \n"
echo "# UpdateProcesStatus Route \n"
echo " ##################################### \n"

echo -e "# Deleting new route Insuance-UpdateProcesStatus-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/Insuance-UpdateProcesStatus-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

echo -e "#Creating new route Insuance-UpdateProcesStatus-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/EaminingMock-service/routes" \
--data "name=Insuance-UpdateProcesStatus-route" \
--data "paths[]=/sandbox/Process_Insurance/v1/Consultant/UpdateProcesStatus" \
--data "methods[]=POST"

echo -e " # Enabling OAuth2 plugin to insuance-assessapplication-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/Insuance-UpdateProcesStatus-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-Insuance-UpdateProcesStatus-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo " ##################################### \n"
echo "# Applicant-SendingCustomerUpdate-route \n"
echo " ##################################### \n"

echo -e "# Deleting new route Applicant-SendingCustomerUpdate-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/Applicant-SendingCustomerUpdate-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

echo -e "#Creating new route Applicant-SendingCustomerUpdate-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/EaminingMock-service/routes" \
--data "name=Applicant-SendingCustomerUpdate-route" \
--data "paths[]=/sandbox/Process_Application/v1/Customer/SendingCustomerUpdate" \
--data "methods[]=POST"

echo " Enabling OAuth2 plugin to Applicant-SendingCustomerUpdate-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/Applicant-SendingCustomerUpdate-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-Applicant-SendingCustomerUpdate-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

cho " ##################################### \n"
echo "# Applicant-GenerateAndSendContract-route \n"
echo " ##################################### \n"

echo -e "# Deleting new route Applicant-GenerateAndSendContract-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/Applicant-GenerateAndSendContract-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

echo -e "#Creating new route Applicant-GenerateAndSendContract-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/EaminingMock-service/routes" \
--data "name=Applicant-GenerateAndSendContract-route" \
--data "paths[]=/sandbox/Process_Application/v1/Customer/GenerateAndSendContract" \
--data "methods[]=POST"

echo " Enabling OAuth2 plugin to Applicant-GenerateAndSendContract-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/Applicant-GenerateAndSendContract-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-Applicant-GenerateAndSendContract-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo " ##################################### \n"
echo "# Insuance-SendContract-route \n"
echo " ##################################### \n"

echo -e "# Deleting new route Insuance-SendContract-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/Insuance-SendContract-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-health-insuance-SendContract-service" | jq -r '.id')
echo "# Deleting service camunda-health-insuance-SendContract-service \n"
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"

echo "# Creating service camunda-health-insuance-SendContract-service \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=camunda-health-insuance-SendContract-service" \
--data "url=${CAMUNDA_ENGINE_MESSAGE_URL}"  

echo -e "#Creating new route Insuance-SendContract-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-health-insuance-SendContract-service/routes" \
--data "name=Insuance-SendContract-route" \
--data "paths[]=/sandbox/Process_Insurance/v1/Consultant/SendContract" \
--data "methods[]=POST"

echo " Enabling OAuth2 plugin to Insuance-SendContract-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/Insuance-SendContract-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-Insuance-SendContract-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo " ##################################### \n"
echo "# Insuance-SaveCustomerData-route \n"
echo " ##################################### \n"

echo -e "# Deleting new route Insuance-SaveCustomerData-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/Insuance-SaveCustomerData-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

echo -e "#Creating new route Insuance-SaveCustomerData-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/EaminingMock-service/routes" \
--data "name=Insuance-SaveCustomerData-route" \
--data "paths[]=/sandbox/Process_Insurance/v1/Consultant/SaveCustomerData" \
--data "methods[]=POST"

echo " Enabling OAuth2 plugin to Insuance-SaveCustomerData-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/Insuance-SaveCustomerData-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-Insuance-SaveCustomerData-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

cho " ##################################### \n"
echo "# Applicant-CleanUpProcerssStatus-route \n"
echo " ##################################### \n"

echo -e "# Deleting new route Applicant-CleanUpProcerssStatus-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/Applicant-CleanUpProcerssStatus-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

echo -e "#Creating new route Applicant-CleanUpProcerssStatus-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/EaminingMock-service/routes" \
--data "name=Applicant-CleanUpProcerssStatus-route" \
--data "paths[]=/sandbox/Process_Application/v1/Customer/CleanUpProcerssStatus" \
--data "methods[]=POST"

echo " Enabling OAuth2 plugin to Applicant-CleanUpProcerssStatus-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/Applicant-CleanUpProcerssStatus-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-Applicant-CleanUpProcerssStatus-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 


echo " ##################################### \n"
echo "# Applicant-SendDecisionAboutContractcAcceptance-route \n"
echo " ##################################### \n"

echo -e "# Deleting new route Applicant-SendDecisionAboutContractcAcceptance-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/Applicant-SendDecisionAboutContractcAcceptance-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-health-Applicant-SendDecisionAboutContractcAcceptance-service" | jq -r '.id')
echo "# Deleting service camunda-health-Applicant-SendDecisionAboutContractcAcceptance-service \n"
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"

echo "# Creating service camunda-health-Applicant-SendDecisionAboutContractcAcceptance-service \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=camunda-health-Applicant-SendDecisionAboutContractcAcceptance-service" \
--data "url=${CAMUNDA_ENGINE_MESSAGE_URL}"  

echo -e "#Creating new route Applicant-SendDecisionAboutContractcAcceptance-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-health-Applicant-SendDecisionAboutContractcAcceptance-service/routes" \
--data "name=Applicant-SendDecisionAboutContractcAcceptance-route" \
--data "paths[]=/sandbox/Process_Application/v1/Customer/SendDecisionAboutContractcAcceptance" \
--data "methods[]=POST"

echo " Enabling OAuth2 plugin to Applicant-SendDecisionAboutContractcAcceptance-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/Applicant-SendDecisionAboutContractcAcceptance-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-Applicant-SendDecisionAboutContractcAcceptance-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 


echo -e " #################### END ####################################### \n"

