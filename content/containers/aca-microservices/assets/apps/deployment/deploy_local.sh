export PUBSUB_NAME='pubsub'
export PUBSUB_TOPIC='orders'
export APP_PORT='3000'

# cd ./apps

# run subscriber
dapr run --app-id subscriber --resources-path ./components --app-port $APP_PORT -- node ./subscriber/server.js

# run publisher (in new console session)
dapr run --app-id publisher --resources-path ./components --app-port $APP_PORT -- node ./publisher/server.js

dapr list

dapr stop order-subscriber
dapr stop order-publisher

