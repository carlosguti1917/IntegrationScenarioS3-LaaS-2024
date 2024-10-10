#!/bin/bash

# create a service for each endpoint
#KONG_SERVER_ADDRESS=ec2-3-237-23-229.compute-1.amazonaws.com
#LAMBDA_URL=https://26sn2b89d1.execute-api.us-east-1.amazonaws.com/test/helloworldpath
KONG_SERVER_ADDRESS=localhost

AWS_CAMUNDA=$addressCamunda
AWS_SHOP=$addressMSShop
AWS_CUSTOMER=$addressMSCustomer
AWS_LOYALTYCARD=$addressMSLoyalty
AWS_PURCHASE=$addressMSPurchase

# AWS_CAMUNDA=ec2-3-87-45-238.compute-1.amazonaws.com
# AWS_SHOP=ec2-3-81-98-57.compute-1.amazonaws.com
# AWS_CUSTOMER=ec2-98-81-5-9.compute-1.amazonaws.com
# AWS_LOYALTYCARD=ec2-3-88-86-215.compute-1.amazonaws.com
# AWS_PURCHASE=ec2-52-87-211-17.compute-1.amazonaws.com


CAMUNDA_ENGINE_URL=http://$AWS_CAMUNDA:8080/engine-rest 
CAMUNDA_ENGINE_MESSAGE_URL=$CAMUNDA_ENGINE_URL/message
### Quarkus endpoints
QUARKUS_CUSTOMER_URL=http://$AWS_CUSTOMER:8080/Customer
QUARKUS_SHOP_URL=http://$AWS_SHOP:8080/Shop
QUARKUS_LOYALTYCARD_URL=http://$AWS_LOYALTYCARD:8080/Loyaltycard
QUARKUS_PURCHASE_URL=http://$AWS_PURCHASE:8080/Purchase

echo $KONG_SERVER_ADDRESS

echo "### Cleaning up Kong APIs Routes ###"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/QuarkusCustomer" | jq -r '.id')
echo 'quarkus-customer-route id = ' $ROUTE_ID
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/QuarkusShop" | jq -r '.id')
echo 'quarkus-shop-route id = ' $ROUTE_ID
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/QuarkusLoyaltycard" | jq -r '.id')
echo 'quarkus-loyaltycard-route id = ' $ROUTE_ID
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/QuarkusPurchase" | jq -r '.id')
echo 'quarkus-purchase-route id = ' $ROUTE_ID
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

echo "Delete the consumer App"
CAMUNDA_APP_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/consumers/CamundaApp" | jq -r '.id')
ECHO 'CamundaApp id = ' $CAMUNDA_APP_ID
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/consumers/${CAMUNDA_APP_ID}"

echo 'LoyaltyCard'
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/RequestLoyaltyCardAssociationOrder" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/PromiseLoyaltyCardAssociationOrder" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/RequestPurchaseConsumerOrder" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/PromisePurchaseConsumerOrder" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/DeclarePurchaseConsumerOrder" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/AcceptPurchaseConsumerOrder" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/DeclareLoyaltyCardAssociationOrder" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/AcceptLoyaltyCardAssociationOrder" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/camunda-engine" | jq -r '.id')
echo 'cleaning route camunda-engine id = ' $ROUTE_ID
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/QuarkusShops" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/QuarkusAssociateLoyaltycard" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"



echo "### Kong APIs Routes Clened Up ### \n"

echo "### Cleaning up Kong APIs Services ### \n"
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

echo " ### Kong APIs services Clened Up ### \n"

### CAMUNDA
echo " #Camunda service and route Cleaned up \n"
echo " ##################################### \n"

echo " #Creating new service camunda-engine \n"
echo " ##################################### \n"

curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=camunda-engine-service" \
--data "url=${CAMUNDA_ENGINE_URL}"
echo ' New service camunda-engine created'
echo " #Creating new route camunda-engine-message-service \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=camunda-engine-message-service" \
--data "url=${CAMUNDA_ENGINE_MESSAGE_URL}" 
echo ' #Creating new route for camunda-engine'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-engine-service/routes" \
--data "name=camunda-engine" \
--data "paths[]=/sandbox/v1/Camunda" \
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


echo '#creating new quarkus-shop-service'

curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=quarkus-shop-service" \
--data "url=${QUARKUS_SHOP_URL}" 


echo '#creating new quarkus-loyaltycard-service '
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=quarkus-loyaltycard-service" \
--data "url=${QUARKUS_LOYALTYCARD_URL}" 

echo '#Loyaltycard service and route created'

echo '#creating new quarkus-purchase-service'

curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=quarkus-purchase-service" \
--data "url=${QUARKUS_PURCHASE_URL}" 


echo 'Purchase service and route created'

echo " ##################################### \n"
echo " Creating consumer CamundaApp \n"
echo " ##################################### \n"

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

echo '# Creating new service camunda-loyalty-association-order-service '
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=camunda-loyalty-association-order-service" \
--data "url=${CAMUNDA_ENGINE_URL}/process-definition/key/ProcessBusinessUnit2/start" 

echo ' #Creating new service RequestPurchaseConsumerOrder-service'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
--data "name=RequestPurchaseConsumerOrder-service" \
--data "url=${CAMUNDA_ENGINE_URL}/process-definition/key/ProcessBusinessUnit3/start" 


echo -e ' ##################################### \n'
echo -e ' #Creating new routings \n'
echo -e ' ##################################### \n'

echo ' #creating quarkus-shop-route '
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/quarkus-shop-service/routes" \
--data "name=QuarkusShop" \
--data "paths[]=/sandbox/ProcessBusinessUnit1/v1/Shop" \
--data "methods[]=GET" \
--data "methods[]=POST"

echo ' \n # creating quarkus-shopname-route \n'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/quarkus-shop-service/routes" \
--data "name=QuarkusShopName" \
--data "paths[]=/sandbox/ProcessBusinessUnit2/v1/ShopName/(?<id>\d+)" \
--data "methods[]=GET" \

echo "#creating new quarkus-customer-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/quarkus-customer-service/routes" \
--data "name=QuarkusCustomer" \
--data "paths[]=/sandbox/ProcessBusinessUnit1/v1/Customer" \
--data "methods[]=GET" \
--data "methods[]=POST"

echo -e " \n#creating new alternative for quarkus-shop-route without oauth \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/quarkus-shop-service/routes" \
--data "name=QuarkusShops" \
--data "paths[]=/sandbox/Shop/v1/Shops" \
--data "methods[]=GET" 

echo -e '#Creating new route RequestLoyaltyCardAssociationOrder-route \n'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-loyalty-association-order-service/routes" \
--data "name=RequestLoyaltyCardAssociationOrder" \
--data "paths[]=/sandbox/ProcessBusinessUnit1/v1/Association/RequestLoyaltyCardAssociationOrder" \
--data "methods[]=POST"

echo  ' \n Creating new route AcceptLoyaltyCardAssociationOrder-route \n'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-engine-message-service/routes" \
--data "name=AcceptLoyaltyCardAssociationOrder" \
--data "paths[]=/sandbox/ProcessBusinessUnit1/v1/Association/AcceptLoyaltyCardAssociationOrder"  \
--data "methods[]=POST"

echo ' \n Creating new route PromiseLoyaltyCardAssociationOrder \n'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-engine-message-service/routes" \
--data "name=PromiseLoyaltyCardAssociationOrder" \
--data "paths[]=/sandbox/ProcessBusinessUnit2/v1/Association/PromiseLoyaltyCardAssociationOrder" \
--data "methods[]=POST"

echo ' \n Creating new route AssociateLoyaltyCard \n'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/quarkus-loyaltycard-service/routes" \
--data "name=QuarkusAssociateLoyaltycard" \
--data "paths[]=/sandbox/ProcessBusinessUnit2/v1/Association/AssociateLoyaltyCard" \
--data "methods[]=POST"

echo ' \n Creating new route DeclareLoyaltyCardAssociationOrder-route \n'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-engine-message-service/routes" \
--data "name=DeclareLoyaltyCardAssociationOrder" \
--data "paths[]=/sandbox/ProcessBusinessUnit2/v1/Association/DeclareLoyaltyCardAssociationOrder"  \
--data "methods[]=POST"

echo '#creating quarkus-loyaltycard-route'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/quarkus-loyaltycard-service/routes" \
--data "name=QuarkusLoyaltycard" \
--data "paths[]=/sandbox/ProcessBusinessUnit2/v1/Card" \
--data "methods[]=GET" \

echo ' #Creating new route RequestPurchaseConsumerOrder-route'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/RequestPurchaseConsumerOrder-service/routes" \
--data "name=RequestPurchaseConsumerOrder" \
--data "paths[]=/sandbox/ProcessBusinessUnit2/v1/Purchase/RequestPurchaseConsumerOrder"  \
--data "methods[]=POST"

echo 'Creating new route AcceptPurchaseConsumerOrder-route'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-engine-message-service/routes" \
--data "name=AcceptPurchaseConsumerOrder" \
--data "paths[]=/sandbox/ProcessBusinessUnit2/v1/Purchase/AcceptPurchaseConsumerOrder"  \
--data "methods[]=POST"

echo 'Creating new route PromisePurchaseConsumerOrder-route'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-engine-message-service/routes" \
--data "name=PromisePurchaseConsumerOrder" \
--data "paths[]=/sandbox/ProcessBusinessUnit3/v1/Purchase/PromisePurchaseConsumerOrder"  \
--data "methods[]=POST"

echo '#creating quarkus-purchase-route'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/quarkus-purchase-service/routes" \
--data "name=QuarkusPurchase" \
--data "paths[]=/sandbox/ProcessBusinessUnit3/v1/Purchase/Consume" \
--data "methods[]=GET" \
--data "methods[]=POST"

echo 'Creating new route DeclarePurchaseConsumerOrder-route'
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-engine-message-service/routes" \
--data "name=DeclarePurchaseConsumerOrder" \
--data "paths[]=/sandbox/ProcessBusinessUnit3/v1/Purchase/DeclarePurchaseConsumerOrder"  \
--data "methods[]=POST"


echo "### ####################################### ### \n"
echo "### Enabling OAuth2 plugin to the created routes ### \n"
echo "### ####################################### ### \n"
echo " Enabling OAuth2 plugin to quarkus-customer \n"

curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/QuarkusCustomer/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-QuarkusCustomer' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' \
--data-urlencode 'tags=Insurance Claims' \
--data-urlencode 'config.scopes=email'

echo " Enabling OAuth2 plugin to quarkus-shop-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/QuarkusShop/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-QuarkusShop' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' \
--data-urlencode 'tags=Insurance Claims' \
--data-urlencode 'config.scopes=email'

echo " \n Enabling OAuth2 plugin to quarkus-shopname-route \n"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/QuarkusShopName/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-QuarkusShopName' \
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
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/QuarkusLoyaltycard/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-QuarkusLoyaltycard' \
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
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/QuarkusPurchase/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-QuarkusPurchase' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' \

echo " Enabling OAuth2 plugin to RequestLoyaltyCardAssociationOrder-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/RequestLoyaltyCardAssociationOrder/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-RequestLoyaltyCardAssociationOrder' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo " Enabling OAuth2 plugin to PromiseLoyaltyCardAssociationOrder-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/PromiseLoyaltyCardAssociationOrder/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-PromiseLoyaltyCardAssociationOrder' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo " Enabling OAuth2 plugin to PromisePurchaseConsumerOrder-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/PromisePurchaseConsumerOrder/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-PromisePurchaseConsumerOrder' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo " Enabling OAuth2 plugin to DeclarePurchaseConsumerOrder"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/DeclarePurchaseConsumerOrder/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-DeclarePurchaseConsumerOrder' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo " Enabling OAuth2 plugin to AcceptPurchaseConsumerOrder-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/AcceptPurchaseConsumerOrder/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-AcceptPurchaseConsumerOrder' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo " Enabling OAuth2 plugin to DeclareLoyaltyCardAssociationOrder-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/DeclareLoyaltyCardAssociationOrder/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-DeclareLoyaltyCardAssociationOrder' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 


echo " Enabling OAuth2 plugin to AcceptLoyaltyCardAssociationOrder-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/AcceptLoyaltyCardAssociationOrder/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-AcceptLoyaltyCardAssociationOrder' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 

echo " Enabling OAuth2 plugin to AssociateLoyaltyCard-route"
curl -i -X POST \
--url "http://${KONG_SERVER_ADDRESS}:8001/routes/QuarkusAssociateLoyaltycard/plugins" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=oauth2' \
--data-urlencode 'instance_name=oauth-QuarkusAssociateLoyaltycard' \
--data-urlencode 'config.enable_client_credentials=true' \
--data-urlencode 'config.enable_authorization_code=true' \
--data-urlencode 'config.global_credentials=true' \
--data-urlencode 'config.provision_key=abc123' \
--data-urlencode 'config.token_expiration=28800' \
--data-urlencode 'config.refresh_token_ttl=1209600' 


echo " ### script building APIs in Kong API Gateway concluded ###"

