#!/bin/bash

# create a service for each endpoint
#KONG_SERVER_ADDRESS=ec2-3-237-23-229.compute-1.amazonaws.com
#LAMBDA_URL=https://26sn2b89d1.execute-api.us-east-1.amazonaws.com/test/helloworldpath
KONG_SERVER_ADDRESS=localhost
CAMUNDA_ENGINE_URL=http://ec2-54-243-14-47.compute-1.amazonaws.com:8080/engine-rest 
CAMUNDA_ENGINE_MESSAGE_URL=http://ec2-54-243-14-47.compute-1.amazonaws.com:8080/engine-rest/message

### Quarkus endpoints
QUARKUS_CUSTOMER_URL=http://ec2-54-172-87-226.compute-1.amazonaws.com:8080/Customer
QUARKUS_SHOP_URL=http://ec2-35-175-245-91.compute-1.amazonaws.com/Shop
QUARKUS_LOYALTYCARD_URL=http://ec2-54-172-87-226.compute-1.amazonaws.com:8080/Loyaltycard
QUARKUS_PURCHASE_URL=http://ec2-54-172-87-226.compute-1.amazonaws.com:8080/Purchase

echo $KONG_SERVER_ADDRESS

echo "### Cleaning up Kong APIs Routes ###"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/quarkus-customer-route" | jq -r '.id')
echo 'quarkus-customer-route id = ' $ROUTE_ID
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/quarkus-shop-route" | jq -r '.id')
echo 'quarkus-shop-route id = ' $ROUTE_ID
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/quarkus-loyaltycard-route" | jq -r '.id')
echo 'quarkus-loyaltycard-route id = ' $ROUTE_ID
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/quarkus-purchase-route" | jq -r '.id')
echo 'quarkus-purchase-route id = ' $ROUTE_ID
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
echo "Delete the consumer App"
CAMUNDA_APP_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/consumers/CamundaApp" | jq -r '.id')
ECHO 'CamundaApp id = ' $CAMUNDA_APP_ID
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/consumers/${CAMUNDA_APP_ID}"
echo 'LoyaltyCard'
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/RequestLoyaltyCardAssociationOrder-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/PromiseLoyaltyCardAssociationOrder-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/RequestPurchaseConsumerOrder-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/PromisePurchaseConsumerOrder-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/DeclarePurchaseConsumerOrder-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/AcceptPurchaseConsumerOrder-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/DeclareLoyaltyCardAssociationOrder-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/AcceptLoyaltyCardAssociationOrder-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/camunda-engine-route" | jq -r '.id')
echo 'cleaning route camunda-engine id = ' $ROUTE_ID
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
echo "### Kong APIs Routes Clened Up ###"

echo "### Cleaning up Kong APIs Services ###"
SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/quarkus-customer-service" | jq -r '.id')
echo 'quarkus-customer-service id = ' $SERVICE_ID
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"
SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/quarkus-shop-service" | jq -r '.id')
echo 'quarkus-shop-service id = ' $SERVICE_ID
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"
SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/quarkus-loyaltycard-service" | jq -r '.id')
echo 'quarkus-loyaltycard-service id = ' $SERVICE_ID
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"
SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/quarkus-purchase-service" | jq -r '.id')
echo 'quarkus-purchase-service id = ' $SERVICE_ID
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"
SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-loyalty-association-order-service" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"
SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/RequestPurchaseConsumerOrder-service" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"
SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-engine-service" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"
SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-engine-message-service" | jq -r '.id')
if [ -n "${SERVICE_ID}" ]; then
    curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"
fi

echo "### Kong APIs services Clened Up ###"

### CAMUNDA
echo '#Camunda service and route Cleaned up'
echo '#Creating new service camunda-engine '
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=camunda-engine-service" \
--data "url=${CAMUNDA_ENGINE_URL}"
echo ' New service camunda-engine created'
echo '#Creating new route camunda-engine-message-service '
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=camunda-engine-message-service" \
--data "url=${CAMUNDA_ENGINE_MESSAGE_URL}" 
echo '#Creating new route for camunda-engine'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-engine-service/routes" \
--data "name=camunda-engine-route" \
--data "paths[]=/sandbox/Camunda" \
--data "methods[]=GET" \
--data "methods[]=POST" \
--data "protocols[]=http" \
--data "protocols[]=https" \
--data "tags[]=camunda" 
echo 'Camunda service and route created'

echo "#creating new quarkus-customer-service"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=quarkus-customer-service" \
--data "url=${QUARKUS_CUSTOMER_URL}" 
echo "#creating new quarkus-customer-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/quarkus-customer-service/routes" \
--data "name=quarkus-customer-route" \
--data "paths[]=/sandbox/Customer" \
--data "methods[]=GET" \
--data "methods[]=POST"

echo '#Customer service and route created'

echo '#creating new quarkus-shop-service'

curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=quarkus-shop-service" \
--data "url=${QUARKUS_SHOP_URL}" 

echo '#creating quarkus-shop-route'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/quarkus-shop-service/routes" \
--data "name=quarkus-shop-route" \
--data "paths[]=/sandbox/Shop" \
--data "paths[]=/sandbox/Shop/(?<id>\d+)" \
--data "methods[]=GET" \
--data "methods[]=POST"

echo 'Shop service and route created'

echo '#creating new quarkus-loyaltycard-service'

curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=quarkus-loyaltycard-service" \
--data "url=${QUARKUS_LOYALTYCARD_URL}" 
echo '#creating quarkus-loyaltycard-route'

curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/quarkus-loyaltycard-service/routes" \
--data "name=quarkus-loyaltycard-route" \
--data "paths[]=/sandbox/Loyaltycard" \
--data "methods[]=GET" \
--data "methods[]=POST"

echo '#Loyaltycard service and route created'

echo '#creating new quarkus-purchase-service'

curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=quarkus-purchase-service" \
--data "url=${QUARKUS_PURCHASE_URL}" 
echo '#creating quarkus-purchase-route'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/quarkus-purchase-service/routes" \
--data "name=quarkus-purchase-route" \
--data "paths[]=/sandbox/Purchase" \
--data "methods[]=GET" \
--data "methods[]=POST"

echo 'Purchase service and route created'

echo 'Creating consumer CamundaApp'

curl -i -X POST http://${KONG_SERVER_ADDRESS}:8001/consumers/ \
  --data "username=CamundaApp"
#Create the credentials for CamundaApp

echo 'Creating credentials for CamundaApp'
curl -i -X POST "http://${KONG_SERVER_ADDRESS}:8001/consumers/CamundaApp/oauth2" \
  --data "name=CamundaApp" \
  --data "client_id=123456" \
  --data "client_secret=415263" \
  --data "redirect_uris[]=http://my-redirect-uri.com"

echo 'Creating fixed token for CamundaApp'
CAMUNDAAPP_CREDENTIAL_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/consumers/CamundaApp/oauth2" | jq -r '.data[0].id')
curl -i -X POST "http://${KONG_SERVER_ADDRESS}:8001/oauth2_tokens" \
  --data "access_token=1234564566878e" \
  --data "token_type=bearer" \
  --data "expires_in=14400" \
  --data "credential.id=${CAMUNDAAPP_CREDENTIAL_ID}" \
  --data "authenticated_userid=123456" \  

echo '#Creating new service camunda-loyalty-association-order-service'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=camunda-loyalty-association-order-service" \
--data "url=${CAMUNDA_ENGINE_URL}/process-definition/key/BusinessActor2LoyaltyCardManagement/start" 

echo '#Creating new route RequestLoyaltyCardAssociationOrder-route'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-loyalty-association-order-service/routes" \
--data "name=RequestLoyaltyCardAssociationOrder-route" \
--data "paths[]=/sandbox/Loyaltycard/RequestLoyaltyCardAssociationOrder" \
--data "methods[]=POST"

echo 'Creating new route PromiseLoyaltyCardAssociationOrder'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-engine-message-service/routes" \
--data "name=PromiseLoyaltyCardAssociationOrder-route" \
--data "paths[]=/sandbox/Loyaltycard/PromiseLoyaltyCardAssociationOrder" \
--data "methods[]=POST"


echo ' #Creating new service RequestPurchaseConsumerOrder-service'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=RequestPurchaseConsumerOrder-service" \
--data "url=${CAMUNDA_ENGINE_URL}/process-definition/key/BusinessActor3LoyaltyCardManagement/start" 

echo ' #Creating new route RequestPurchaseConsumerOrder-route'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/RequestPurchaseConsumerOrder-service/routes" \
--data "name=RequestPurchaseConsumerOrder-route" \
--data "paths[]=/sandbox/Consumer/RequestPurchaseConsumerOrder"  \
--data "methods[]=POST"


echo 'Creating new route PromisePurchaseConsumerOrder-route'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-engine-message-service/routes" \
--data "name=PromisePurchaseConsumerOrder-route" \
--data "paths[]=/sandbox/Consumer/PromisePurchaseConsumerOrder"  \
--data "methods[]=POST"


echo 'Creating new route DeclarePurchaseConsumerOrder-route'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-engine-message-service/routes" \
--data "name=DeclarePurchaseConsumerOrder-route" \
--data "paths[]=/sandbox/Consumer/DeclarePurchaseConsumerOrder"  \
--data "methods[]=POST"

echo 'Creating new route AcceptPurchaseConsumerOrder-route'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-engine-message-service/routes" \
--data "name=AcceptPurchaseConsumerOrder-route" \
--data "paths[]=/sandbox/Customer/AcceptPurchaseConsumerOrder"  \
--data "methods[]=POST"


echo 'Creating new route DeclareLoyaltyCardAssociationOrder-route'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-engine-message-service/routes" \
--data "name=DeclareLoyaltyCardAssociationOrder-route" \
--data "paths[]=/sandbox/Loyalty/DeclareLoyaltyCardAssociationOrder"  \
--data "methods[]=POST"

echo  'Creating new route AcceptLoyaltyCardAssociationOrder-route'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-engine-message-service/routes" \
--data "name=AcceptLoyaltyCardAssociationOrder-route" \
--data "paths[]=/sandbox/Loyalty/AcceptLoyaltyCardAssociationOrder"  \
--data "methods[]=POST"

echo "### Enabling OAuth2 plugin to the created routes ###"
echo " Enabling OAuth2 plugin to quarkus-customer-route "
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/quarkus-customer-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-quarkus-customer-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' \
--data-urlencode 'tags=Insurance Claims' \
--data-urlencode 'config.scopes=email'

echo " Enabling OAuth2 plugin to quarkus-shop-service"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/quarkus-shop-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-quarkus-shop-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' \
--data-urlencode 'tags=Insurance Claims' \
--data-urlencode 'config.scopes=email'

echo " Enabling OAuth2 plugin to quarkus-loyaltycard-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/quarkus-loyaltycard-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-quarkus-loyaltycard-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' \
--data-urlencode 'tags=Insurance Claims' \
--data-urlencode 'config.scopes=email'

echo " Enabling OAuth2 plugin to quarkus-purchase-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/quarkus-purchase-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-quarkus-purchase-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' \

echo " Enabling OAuth2 plugin to RequestLoyaltyCardAssociationOrder-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/RequestLoyaltyCardAssociationOrder-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-RequestLoyaltyCardAssociationOrder-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo " Enabling OAuth2 plugin to PromiseLoyaltyCardAssociationOrder-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/PromiseLoyaltyCardAssociationOrder-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-PromiseLoyaltyCardAssociationOrder-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo " Enabling OAuth2 plugin to PromisePurchaseConsumerOrder-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/PromisePurchaseConsumerOrder-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-PromisePurchaseConsumerOrder-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo " Enabling OAuth2 plugin to DeclarePurchaseConsumerOrder-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/DeclarePurchaseConsumerOrder-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-DeclarePurchaseConsumerOrder-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo " Enabling OAuth2 plugin to AcceptPurchaseConsumerOrder-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/AcceptPurchaseConsumerOrder-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-AcceptPurchaseConsumerOrder-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo " Enabling OAuth2 plugin to DeclareLoyaltyCardAssociationOrder-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/DeclareLoyaltyCardAssociationOrder-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-DeclareLoyaltyCardAssociationOrder-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 


echo " Enabling OAuth2 plugin to AcceptLoyaltyCardAssociationOrder-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/AcceptLoyaltyCardAssociationOrder-route/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-AcceptLoyaltyCardAssociationOrder-route' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo " ### script concluded ###"

