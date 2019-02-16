FROM alpine:3.8

ENV TERRAFORM_VERSION=0.11.11
ENV TERRAGRUNT_VERSION=v0.17.4
ENV LANDSCAPE_VERSION=0.3.0

ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip .
RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin \
    && chmod +x /usr/local/bin/terraform

RUN set -ex \
    && apk update \
    && apk --no-cache add ruby-bundler=1.16.2-r1 \
                          ruby-json=2.5.2-r0 \
                          diffutils=3.6-r1 \
    && apk add --no-cache --virtual .build-deps gcc make musl-dev linux-headers ruby-dev \
    && gem install --no-document --no-ri terraform_landscape:${LANDSCAPE_VERSION} \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*

ADD https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 /usr/local/bin/terragrunt
RUN chmod +x /usr/local/bin/terragrunt
