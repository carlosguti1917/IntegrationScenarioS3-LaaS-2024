#!/bin/bash

# create a service for each endpoint
#KONG_SERVER_ADDRESS=ec2-3-237-23-229.compute-1.amazonaws.com
KONG_SERVER_ADDRESS=localhost

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


### Nobel Prize Case
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"
SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-prizenominator-service" | jq -r '.id')
echo " ### Kong APIs services Clened Up ### \n"

echo "Prize Nomination \n'"
echo -e "# Deleting new route prize-nominator-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/prize-nominator-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

### HealthCare Case

echo -e "# Deleting new route applicant-sendinformation-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/applicant-sendinformation-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-health-insuance-service" | jq -r '.id')
echo "# Deleting service camunda-health-insuance-service \n"
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"

echo -e "# Deleting new route insuance-assessapplication-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/insuance-assessapplication-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-health-assessapplication-service" | jq -r '.id')
echo "# Deleting service camunda-health-assessapplication-service \n"
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"

echo -e "# Deleting new route Applicant-SaveProcesStatus-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/Applicant-SaveProcesStatus-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

echo -e "# Deleting new route Insuance-UpdateProcesStatus-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/Insuance-UpdateProcesStatus-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

echo -e "# Deleting new route Insuance-InformAboutAcceptance-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/Insuance-InformAboutAcceptance-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-health-insuance-InformAboutAcceptance-service" | jq -r '.id')
echo "# Deleting service camunda-health-insuance-InformAboutAcceptance-service \n"
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"

echo -e "# Deleting new route Insuance-InformAboutRejection-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/Insuance-InformAboutRejection-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-health-insuance-InformAboutRejection-service" | jq -r '.id')
echo "# Deleting service camunda-health-insuance-InformAboutRejection-service \n"
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"

echo -e "# Deleting new route Insuance-InformAboutOffer-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/Insuance-InformAboutOffer-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-health-insuance-InformAboutOffer-service" | jq -r '.id')
echo "# Deleting service camunda-health-insuance-InformAboutOffer-service \n"
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"

echo -e "# Deleting new route Insuance-UpdateProcesStatus-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/Insuance-UpdateProcesStatus-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

echo -e "# Deleting new route Applicant-SendingCustomerUpdate-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/Applicant-SendingCustomerUpdate-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

echo -e "# Deleting new route Applicant-GenerateAndSendContract-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/Applicant-GenerateAndSendContract-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

echo -e "# Deleting new route Insuance-SendContract-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/Insuance-SendContract-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-health-insuance-SendContract-service" | jq -r '.id')
echo "# Deleting service camunda-health-insuance-SendContract-service \n"
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"

echo -e "# Deleting new route Insuance-SaveCustomerData-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/Insuance-SaveCustomerData-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

echo -e "# Deleting new route Applicant-CleanUpProcerssStatus-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/Applicant-CleanUpProcerssStatus-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

echo -e "# Deleting new route Applicant-SendDecisionAboutContractcAcceptance-route \n"
ROUTE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/routes/Applicant-SendDecisionAboutContractcAcceptance-route" | jq -r '.id')
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/routes/${ROUTE_ID}"

SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/camunda-health-Applicant-SendDecisionAboutContractcAcceptance-service" | jq -r '.id')
echo "# Deleting service camunda-health-Applicant-SendDecisionAboutContractcAcceptance-service \n"
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"

## Mock Route
echo "# Mock Route \n"

SERVICE_ID=$(curl -s "http://${KONG_SERVER_ADDRESS}:8001/services/EaminingMock-service" | jq -r '.id')
echo "# Deleting service EaminingMockservice \n"
curl -i -X DELETE "http://${KONG_SERVER_ADDRESS}:8001/services/${SERVICE_ID}"
echo "### Kong APIs Routes Clened Up ### \n"