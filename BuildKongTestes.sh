#!/bin/bash

# create a service for each endpoint
#KONG_SERVER_ADDRESS=ec2-3-237-23-229.compute-1.amazonaws.com
KONG_SERVER_ADDRESS=192.168.0.15
#LAMBDA_URL=https://26sn2b89d1.execute-api.us-east-1.amazonaws.com/test/helloworldpath
CAMUNDA_ENGINE_URL=http://ec2-54-243-14-47.compute-1.amazonaws.com:8080/engine-rest 
CAMUNDA_ENGINE_MESSAGE_URL=http://ec2-54-243-14-47.compute-1.amazonaws.com:8080/engine-rest/message
### Quarkus endpoints
QUARKUS_CUSTOMER_URL=http://ec2-54-172-87-226.compute-1.amazonaws.com:8080/Customer
QUARKUS_SHOP_URL=http://ec2-35-175-245-91.compute-1.amazonaws.com/Shop
QUARKUS_LOYALTYCARD_URL=http://ec2-54-172-87-226.compute-1.amazonaws.com:8080/Loyaltycard
QUARKUS_PURCHASE_URL=http://ec2-54-172-87-226.compute-1.amazonaws.com:8080/Purchase


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


# curl -i -X POST \
# --url "http://${KONG_SERVER_ADDRESS}:8001/services/" \
# --data "name=quarkus-purchase-service" \
# --data "url=${QUARKUS_PURCHASE_URL}" 

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



