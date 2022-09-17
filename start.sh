echo '1. Create image of the spring boot app'

cd ms-request-verify
gradle clean build
docker build --build-arg JAR_FILE=build/libs/\*.jar -t demo-app/ms-request-verify .

echo '2. Start Docker containers to setup encironment'
cd ..
docker compose up -d

echo '3. After starting the kong will be in crashLoop, you need to add new plugin'
docker cp request-response-logger/. kong:/usr/local/share/lua/5.1/kong/plugins/request-response-logger
docker restart kong

echo '4. Spring Boot aplication should be added to Kong as a service and plugin should be enabled'
echo '4.1. New service should be created'
curl --location --write-out --request POST "http://localhost:8001/services" --header "Content-Type:application/json" --data-raw '{"name":"ms-request-verify","url" :"http://ms-request-verify:8080"}'


echo '4.2. Route should be set'
curl --location --write-out --request POST "http://localhost:8001/services/ms-request-verify/routes" \
--header "Content-Type:application/json" \
--data-raw '{
    "name": "ms-request-verify-routes0",
    "paths": [
        "/"
    ],
    "strip_path": true
}'

echo '4.3. Plugin should be enabled'
curl --location  --write-out --request POST "http://localhost:8001/plugins" \
--header "Content-Type:application/json" \
--data-raw '{
    "name":"request-response-logger",
    "enabled":true
}'

echo '5. Ping the new end point and see from the logs if the request and response is logged with command "docker logs ms-request-verify"'
curl --location --request GET 'http://localhost:8000/api/v1/ping' \
--header 'x-request-id: 1111'

docker logs ms-request-verify 
