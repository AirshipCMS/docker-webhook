FROM mhart/alpine-node:0.12

MAINTAINER Jon Borgonia "jon@gomagames.com"

# build git
RUN apk --update add git

ADD webhook.js /srv/index.js
ADD package.json /srv/package.json

RUN cd /srv && npm install

# build fleet
RUN apk-install curl && \
    curl -LOks https://github.com/coreos/fleet/releases/download/v${VERSION}/fleet-v${VERSION}-linux-amd64.tar.gz && \
    tar zxvf fleet-v${VERSION}-linux-amd64.tar.gz && \
    cp fleet-v${VERSION}-linux-amd64/fleetctl /bin/fleetctl && \
    rm -rf fleet-v* && \
    chmod +x /bin/fleetctl

# url of fleet
# FLEETCTL_ENDPOINT=${COREOS_PRIVATE_IPV4}
# FLEETCTL_ENDPOINT=${COREOS_PRIVATE_IPV4}:4001
ENV FLEETCTL_ENDPOINT=127.0.0.1:4001

# secret auth token manually generated for docker webhook
# http://yourfleet.com:8411/YOUR_SECRET_AUTH_TOKEN
ENV AUTH_TOKEN=YOUR_SECRET

# node ids to reload when webhook is triggered
ENV AIRSHIP_IDX=[0]

EXPOSE 8411

WORKDIR /srv

CMD ["node ."]
