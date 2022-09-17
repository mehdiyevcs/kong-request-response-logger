## Kong Plugin: Log the kong request and response to external system

### Description:
### The plugin is designed to store kong request logs and kong response logs in an external system.
### The history of the investigation began with the business need to record every user action at a single point of change. (Something like Audit Logging of the User actions)
### As a result of the investigation, it was found that it is possible to send both the request and the response received by Kong to the external system (some kind of ms-audit)

> NOTE:
>  In order to automatically start the network (included the kong and app) , you are able to use the start.sh shell script buy executing following command in the root:
>  `./start.sh`
>  In case of lack of permission use below command before
>  `chmod a+rx start.sh`
>  The detailed description of the commands can be found below.


### Steps
####  1. Create image of the spring boot app

    cd ms-request-verify
    gradle clean build
    docker build --build-arg JAR_FILE=build/libs/\*.jar -t demo-app/ms-request-verify .

#### 2. Start Docker containers to setup encironment

    cd ..
    docker compose up -d

#### 3. After starting the kong will be in crashLoop, you need to add new plugin

    docker cp request-response-logger/. kong:/usr/local/share/lua/5.1/kong/plugins/request-response-logger
    docker restart kong

#### 4. Spring Boot application should be added to Kong as a service and plugin should be enabled

##### 4.1. New service should be created'
    curl --location --write-out --request POST "http://localhost:8001/services" --header "Content-Type:application/json" --data-raw '{"name":"ms-request-verify","url" :"http://ms-request-verify:8080"}'


##### 4.2. Route should be set

    curl --location --write-out --request POST "http://localhost:8001/services/ms-request-verify/routes" \
    --header "Content-Type:application/json" \
    --data-raw '{
        "name": "ms-request-verify-routes0",
        "paths": [
            "/"
        ],
        "strip_path": true
    }'

##### 4.3. Plugin should be enabled

    curl --location  --write-out --request POST "http://localhost:8001/plugins" \
    --header "Content-Type:application/json" \
    --data-raw '{
        "name":"request-response-logger",
        "enabled":true
    }'

#### 5. Ping the new end point and see from the logs if the request and response is logged with command "docker logs ms-request-verify"

    curl --location --request GET 'http://localhost:8000/api/v1/ping' \
    --header 'x-request-id: 1111'
    
    docker logs ms-request-verify 


