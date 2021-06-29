FROM golang:alpine as builder
RUN mkdir /build 
ADD . /build/
COPY go.mod /go/src/github.com/flostadler/name-generator/cmd/name-generator/go.mod
COPY go.sum /go/src/github.com/flostadler/name-generator/cmd/name-generator/go.sum
RUN apk add git
WORKDIR /build
RUN go mod download
RUN go build -o main github.com/flostadler/name-generator/cmd/name-generator
FROM node:12-alpine as node-builder
RUN apk add git
ADD . .
WORKDIR /web
RUN npm install
RUN npm run build --if-present
FROM nginx
HEALTHCHECK --interval=1m --timeout=3s CMD curl -f http://localhost/ || exit 1
COPY --from=node-builder /web/build /usr/share/nginx/html/

