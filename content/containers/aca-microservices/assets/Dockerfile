# FROM node:19.3.0
FROM node:19-alpine3.16 as builder

ENV NODE_ENV=production
WORKDIR /app
COPY ["package.json", "package-lock.json*", "./"]
COPY . .
RUN npm install --production

# remove development dependencies
RUN npm prune --production

FROM node:19-alpine3.16
WORKDIR /app

# copy from build image
COPY --from=builder /app .
COPY --from=builder /app/node_modules ./node_modules

EXPOSE 3000
CMD [ "node", "./server.js" ]