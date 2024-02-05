#!/bin/bash


if [ ! -x "$(which certbot)" ]; then
   echo You have to install certbot
   exit 1
fi

CERTBOT_ARGS=()

function parse_eab_credentials()
{
    python=$(command -v python3 || command -v python)
    case "$("$python" -V)" in
      ('Python 3'*) ;;
      (*) echo 'No python3 detected'; exit 1 ;;
    esac
    pyprog='import sys, json; js = json.loads(sys.argv[1]); print(js["eab_kid"]); print(js["eab_hmac_key"]);';
    {
      IFS= read -r ZEROSSL_EAB_KID &&
      IFS= read -r ZEROSSL_EAB_HMAC_KEY
    } <<< "$( PYTHONIOENCODING=utf8 "$python" -c "$pyprog" "$1" )"
    CERTBOT_ARGS+=(--eab-kid "${ZEROSSL_EAB_KID:?}" --eab-hmac-key "${ZEROSSL_EAB_HMAC_KEY:?}" --server "https://acme.zerossl.com/v2/DV90")
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --zerossl-api-key=*)
            ZEROSSL_API_KEY=${1#*=}
        ;;
        --zerossl-api-key|-z)
           ZEROSSL_API_KEY=$2
           shift
        ;;
        --zerossl-email=*)
            ZEROSSL_EMAIL=${1#*=}
        ;;
        --email|--zerossl-email|-m)
           ZEROSSL_EMAIL=$2
           CERTBOT_ARGS+=(-m "$2")
           shift
        ;;
        *) CERTBOT_ARGS+=("$1") ;;
    esac
    shift
done

set -- "${CERTBOT_ARGS[@]}"

if [[ -n $ZEROSSL_API_KEY ]]; then
    parse_eab_credentials "$(curl -s -X POST "https://api.zerossl.com/acme/eab-credentials?access_key=$ZEROSSL_API_KEY")"
elif [[ -n $ZEROSSL_EMAIL ]]; then
    parse_eab_credentials "$(curl -s https://api.zerossl.com/acme/eab-credentials-email --data "email=$ZEROSSL_EMAIL")"
fi

printf '%s ' certbot "${CERTBOT_ARGS[@]}"; echo
certbot "${CERTBOT_ARGS[@]}"
