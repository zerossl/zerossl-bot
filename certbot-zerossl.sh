#!/bin/bash

CERTBOT_ARGS=()

function parse_eab_credentials()
{
    PYTHONIOENCODING=utf8
    ZEROSSL_EAB_KID=$(echo $1 | python -c "import sys, json; print(json.load(sys.stdin)['eab_kid'])")
    ZEROSSL_EAB_HMAC_KEY=$(echo $1 | python -c "import sys, json; print(json.load(sys.stdin)['eab_hmac_key'])")
    
    # Check if hmac key starts with dash - this will confuse python or certbot, see https://github.com/certbot/certbot/issues/7114
	if  [[ $ZEROSSL_EAB_HMAC_KEY != -* ]];	then
	    GOOD_KEY_FOUND=true
	    CERTBOT_ARGS+=(--eab-kid "$ZEROSSL_EAB_KID" --eab-hmac-key "$ZEROSSL_EAB_HMAC_KEY" --server "https://acme.zerossl.com/v2/DV90")
    else
        echo "Got hmac key with leading dash, retrying..."
    fi
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --zerossl-api-key=*)
            ZEROSSL_API_KEY="${1:18}"
        ;;
        --zerossl-api-key|-z)
            ZEROSSL_API_KEY="${2}"
            shift
        ;;
        --deploy-hook) 
            DEPLOY_HOOK="${2}"
            echo "Parsing deploy-hook: """${2}""""
            CERTBOT_ARGS+=(--deploy-hook """${2}""")
            shift
        ;;
        --email|--zerossl-email|-m)
            ZEROSSL_EMAIL="${2}"
            CERTBOT_ARGS+=(-m "${2}")
            shift
        ;;
        *) CERTBOT_ARGS+=($1) ;;
    esac
    shift
done

if [[ -n $ZEROSSL_API_KEY ]]; then

	# Retry until we get one hmac key without leading dash
    GOOD_KEY_FOUND=false
    while ! $GOOD_KEY_FOUND; do
        parse_eab_credentials $(curl -s -X POST "https://api.zerossl.com/acme/eab-credentials?access_key=$ZEROSSL_API_KEY")
    done
    
elif [[ -n $ZEROSSL_EMAIL ]]; then
    parse_eab_credentials $(curl -s https://api.zerossl.com/acme/eab-credentials-email --data "email=$ZEROSSL_EMAIL")
fi

echo "$(date) Calling: certbot ${CERTBOT_ARGS[@]}"
certbot "${CERTBOT_ARGS[@]}"
