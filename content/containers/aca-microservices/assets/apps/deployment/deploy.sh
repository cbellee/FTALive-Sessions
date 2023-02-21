LOCATION='eastus'
RG_NAME='aca-dapr-demo-eus-rg'

SUB_APP_NAME='subscriber'
SUB_APP_PORT=3000

PUB_APP_NAME='publisher'
PUB_APP_PORT=3000

STATE_STORE_NAME='state'
PUB_SUB_NAME='pubsub'
TOPIC_NAME='orders'

TAG='v0.1.0'

# cd ./apps/deplyoment

# deploy resource group
az group create --name $RG_NAME --location $LOCATION

# deploy ACR
ACR_NAME=`az deployment group create \
    --name 'acr-deployment' \
    --resource-group $RG_NAME \
    --template-file ./modules/acr.bicep \
    --parameters location=$LOCATION \
    --query properties.outputs.name.value -o tsv`

# build container images
az acr build \
    -t $PUB_APP_NAME:$TAG \
    --registry $ACR_NAME \
    -f ../../Dockerfile \
    ../publisher

az acr build \
    -t $SUB_APP_NAME:$TAG \
    --registry $ACR_NAME \
    -f ../../Dockerfile \
    ../subscriber

# deploy environment
az deployment group create \
    --name 'aca-deployment' \
    --resource-group $RG_NAME \
    --template-file ./main.bicep \
    --parameters location=$LOCATION \
    --parameters tag=$TAG \
    --parameters acrName=$ACR_NAME \
    --parameters pubAppName=$PUB_APP_NAME \
    --parameters pubAppPort=$PUB_APP_PORT \
    --parameters subAppName=$SUB_APP_NAME \
    --parameters subAppPort=$SUB_APP_PORT \
    --parameters pubSubName=$PUB_SUB_NAME \
    --parameters topicName=$TOPIC_NAME
    # --parameters deployServiceBus='true'

# az containerapp logs show -g $RG_NAME -n sub --follow
# az containerapp logs show -g $RG_NAME -n pub --follow
