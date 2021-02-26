# ARG IMAGE_NAME=${CI_REGISTRY_IMAGE}/${DEPLOY_PROJECT_NAME}_app
FROM docker-hub.iss-reshetnev.ru/714/7141/svt/svt-test_app:latest AS app
FROM nginx:1.19.6-alpine

ARG RAILS_ROOT
ENV RAILS_ROOT ${RAILS_ROOT}

WORKDIR ${RAILS_ROOT}
RUN mkdir log
COPY --from=app /app/public/ public/

COPY docker/nginx/nginx.prod.conf /tmp/nginx.prod.conf
COPY docker/tls/ /etc/pki/tls/nginx/

RUN envsubst '$RAILS_ROOT $APPNAME' < /tmp/nginx.prod.conf > /etc/nginx/conf.d/default.conf

EXPOSE 80
EXPOSE 443