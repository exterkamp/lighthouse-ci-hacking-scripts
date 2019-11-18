# arm32 v6 image for Raspberry pi 1 B+
FROM arm32v6/node:alpine

# Load the lhci data
WORKDIR /usr/src/lhci
COPY package.json .
COPY lighthouserc.json .

# alpine doesn't come with python, so we need to load our deps manually
RUN apk add --no-cache --virtual .gyp \
        python \
        make \
        g++ \
    && npm install \
    && apk del .gyp

# Start lhci server
EXPOSE 9001
CMD [ "npm", "start" ]