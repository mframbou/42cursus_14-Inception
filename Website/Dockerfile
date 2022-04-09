FROM alpine:3.14

RUN apk update && apk add npm nodejs

# https://nodejs.org/en/docs/guides/nodejs-docker-webapp/

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY ./web ./

RUN npm install
# If you are building your code for production
# RUN npm ci --only=production

CMD [ "node", "server.js" ]