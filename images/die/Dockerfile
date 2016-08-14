FROM alpine:3.4

RUN apk add --no-cache git nodejs && \
    git clone https://github.com/lapwinglabs/100-ways-to-die && \
    cd 100-ways-to-die && \
    npm install

WORKDIR /100-ways-to-die

ENTRYPOINT npm start
