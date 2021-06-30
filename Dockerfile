FROM node:12-alpine as node-builder
RUN apk add git
COPY . .
WORKDIR /web
RUN npm install
RUN npm run build --if-present
FROM nginx
HEALTHCHECK --interval=10s --retries=2 --timeout=3s CMD curl -f http://localhost/ || exit 1
COPY --from=node-builder /web/build /usr/share/nginx/html/

