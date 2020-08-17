#!/bin/bash


CERTBOT_SCRIPT_LOCATION=${CERTBOT_SCRIPT_LOCATION-"https://certbot.zerossl.com/certbot-zerossl.sh"}

function install_certbot()
{
    sudo bash <<EOF
        curl -s "$CERTBOT_SCRIPT_LOCATION" > /tmp/certbot-zerossl && \
        mkdir -p /usr/local/bin
        mv /tmp/certbot-zerossl /usr/local/bin/certbot-zerossl && \
        chmod +x /usr/local/bin/certbot-zerossl
EOF
}

install_certbot
