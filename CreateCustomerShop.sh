### Creates 10 customers and 10 Shops for teste

AWS_CUSTOMER=$addressMSCustomer
AWS_SHOP=$addressMSShop

#AWS_CUSTOMER=ec2-98-81-5-9.compute-1.amazonaws.com
#AWS_SHOP=ec2-44-202-56-244.compute-1.amazonaws.com

QUARKUS_CUSTOMER_URL=http://$AWS_CUSTOMER:8080/Customer
QUARKUS_SHOP_URL=http://$AWS_SHOP:8080/Shop

echo "#######                ####### \n"
echo "#######  Creating Customers \n"
echo "#######                ####### "

curl -i -X POST \
--url "${QUARKUS_CUSTOMER_URL}" \
--header 'Content-Type: application/json' \
--data '{"FiscalNumber": 123456010, "id":5, "location":"Lisbon", "name":"Andrea de Santos"}' 

curl -i -X POST \
--url "${QUARKUS_CUSTOMER_URL}" \
--header 'Content-Type: application/json' \
--data '{"FiscalNumber": 12345602, "id":6, "location":"Faro", "name":"Rogerio Farol"}' 

curl -i -X POST \
--url "${QUARKUS_CUSTOMER_URL}" \
--header 'Content-Type: application/json' \
--data '{"FiscalNumber": 12345603, "id":7, "location":"Tijucas   ", "name":"Pauo Antoniote"}' 

curl -i -X POST \
--url "${QUARKUS_CUSTOMER_URL}" \
--header 'Content-Type: application/json' \
--data '{"FiscalNumber": 12345604, "id":8, "location":"Faro", "name":"Thiago Abrantes"}' 

curl -i -X POST \
--url "${QUARKUS_CUSTOMER_URL}" \
--header 'Content-Type: application/json' \
--data '{"FiscalNumber": 12345604, "id":9, "location":"Faro", "name":"Guilherme Amaral"}' 

curl -i -X POST \
--url "${QUARKUS_CUSTOMER_URL}" \
--header 'Content-Type: application/json' \
--data '{"FiscalNumber": 123456010, "id":10, "location":"Lisbon", "name":"Andrea de Souza"}' 

curl -i -X POST \
--url "${QUARKUS_CUSTOMER_URL}" \
--header 'Content-Type: application/json' \
--data '{"FiscalNumber": 12345602, "id":11, "location":"Fato", "name":"Rodrigo Faro"}' 

curl -i -X POST \
--url "${QUARKUS_CUSTOMER_URL}" \
--header 'Content-Type: application/json' \
--data '{"FiscalNumber": 12345603, "id":12, "location":"Tijucas   ", "name":"Pedro Antonio"}' 

curl -i -X POST \
--url "${QUARKUS_CUSTOMER_URL}" \
--header 'Content-Type: application/json' \
--data '{"FiscalNumber": 12345604, "id":13, "location":"Faro", "name":"Tiago Dantas"}' 

curl -i -X POST \
--url "${QUARKUS_CUSTOMER_URL}" \
--header 'Content-Type: application/json' \
--data '{"FiscalNumber": 12345605, "id":14, "location":"Lisbon", "name":"Thiago de Jesus"}' 

curl -i -X POST \
--url "${QUARKUS_CUSTOMER_URL}" \
--header 'Content-Type: application/json' \
--data '{"FiscalNumber": 12345606, "id":15, "location":"Lisbon", "name":"Willian Default"}' 

curl -i -X POST \
--url "${QUARKUS_CUSTOMER_URL}" \
--header 'Content-Type: application/json' \
--data '{"FiscalNumber": 12345607, "id":16, "location":"Monaco", "name":"Pietro Chatonelli"}' 

curl -i -X POST \
--url "${QUARKUS_CUSTOMER_URL}" \
--header 'Content-Type: application/json' \
--data '{"FiscalNumber": 12345608, "id":17, "location":"London", "name":"Michael Lambert"}' 

curl -i -X POST \
--url "${QUARKUS_CUSTOMER_URL}" \
--header 'Content-Type: application/json' \
--data '{"FiscalNumber": 123456018, "id":18, "location":"London", "name":"Michael Lambert"}' 

curl -i -X POST \
--url "${QUARKUS_CUSTOMER_URL}" \
--header 'Content-Type: application/json' \
--data '{"FiscalNumber": 123456019, "id":19, "location":"London", "name":"Michael Lambert"}' 

curl -i -X POST \
--url "${QUARKUS_CUSTOMER_URL}" \
--header 'Content-Type: application/json' \
--data '{"FiscalNumber": 123456020, "id":20, "location":"London", "name":"Mike Amundsen"}' 

curl -i -X POST \
--url "${QUARKUS_CUSTOMER_URL}" \
--header 'Content-Type: application/json' \
--data '{"FiscalNumber": 123456021, "id":21, "location":"London", "name":"Paul MacCartnels"}'

sleep 1m

echo "############## Creating Shops ##################### "
echo '# addressMSShop = '$addressMSShop 
echo '# \n QUARKUS_SHOP_URL = '$QUARKUS_SHOP_URL 
echo " ################################################## "

curl -i -X POST \
--url "${QUARKUS_SHOP_URL}" \
--header 'Content-Type: application/json' \
--data '{"id":5, "location":"Lisbon", "name":"Andrea de Santos"}' 

curl -i -X POST \
--url "${QUARKUS_SHOP_URL}" \
--header 'Content-Type: application/json' \
--data '{"id":6, "location":"Faro", "name":"Rogerio Farol"}' 

curl -i -X POST \
--url "${QUARKUS_SHOP_URL}" \
--header 'Content-Type: application/json' \
--data '{"id":7, "location":"Tijucas", "name":"Pauo Antoniote"}' 

curl -i -X POST \
--url "${QUARKUS_SHOP_URL}" \
--header 'Content-Type: application/json' \
--data '{"id":8, "location":"Faro", "name":"Thiago Abrantes"}' 

curl -i -X POST \
--url "${QUARKUS_SHOP_URL}" \
--header 'Content-Type: application/json' \
--data '{"id":9, "location":"Faro", "name":"Guilherme Amaral"}' 

curl -i -X POST \
--url "${QUARKUS_SHOP_URL}" \
--header 'Content-Type: application/json' \
--data '{"id":10, "location":"Lisbon", "name":"Andrea de Souza"}' 

curl -i -X POST \
--url "${QUARKUS_SHOP_URL}" \
--header 'Content-Type: application/json' \
--data '{"id":11, "location":"Fato", "name":"Rodrigo Faro"}' 

curl -i -X POST \
--url "${QUARKUS_SHOP_URL}" \
--header 'Content-Type: application/json' \
--data '{"id":12, "location":"Tijucas   ", "name":"Pedro Antonio"}' 

curl -i -X POST \
--url "${QUARKUS_SHOP_URL}" \
--header 'Content-Type: application/json' \
--data '{"id":13, "location":"Faro", "name":"Tiago Dantas"}' 

curl -i -X POST \
--url "${QUARKUS_SHOP_URL}" \
--header 'Content-Type: application/json' \
--data '{"id":14, "location":"Lisbon", "name":"Thiago de Jesus"}' 

curl -i -X POST \
--url "${QUARKUS_SHOP_URL}" \
--header 'Content-Type: application/json' \
--data '{"id":15, "location":"Lisbon", "name":"Willian Default"}' 

curl -i -X POST \
--url "${QUARKUS_SHOP_URL}" \
--header 'Content-Type: application/json' \
--data '{"id":16, "location":"Monaco", "name":"Pietro Chatonelli"}' 

curl -i -X POST \
--url "${QUARKUS_SHOP_URL}" \
--header 'Content-Type: application/json' \
--data '{"id":17, "location":"London", "name":"Michael Lambert"}' 

curl -i -X POST \
--url "${QUARKUS_SHOP_URL}" \
--header 'Content-Type: application/json' \
--data '{"id":18, "location":"Berlin", "name":"Michael Shomarkenezer"}' 

curl -i -X POST \
--url "${QUARKUS_SHOP_URL}" \
--header 'Content-Type: application/json' \
--data '{"id":19, "location":"Brasilia", "name":"Marcos Nicolelis"}' 

curl -i -X POST \
--url "${QUARKUS_SHOP_URL}" \
--header 'Content-Type: application/json' \
--data '{"id":20, "location":"London", "name":"Mike Amundsen"}' 

curl -i -X POST \
--url "${QUARKUS_SHOP_URL}" \
--header 'Content-Type: application/json' \
--data '{"id":21, "location":"London", "name":"Paul MacCartnels"}' 

echo " Customers and Shops Created for Test "

