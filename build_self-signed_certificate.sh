#!/bin/sh

SERVER_NAME="$1"
CA_NAME="$2"
DEFAULT_DAYS="$3"

usage() {
        echo "$0 SERVER_NAME CA_NAME [ DEFAULT_DAYS ]"
        echo "Exemple : $0 myserver myca"
}

[ -z $SERVER_NAME ] && usage && exit 1
[ -z $CA_NAME ] && usage && exit 1


# File conf
[ -f "vars" ] && . vars

# Make Server Private Key
echo -e "\nMake Server Private Key : ${SERVER_NAME}.key\n"
openssl genrsa -des3 -out ${SERVER_NAME}.key 1024

# Make Certificate Signing Request (csr)
echo -e "\nMake Certificate Signing Request : ${SERVER_NAME}.csr\n"
openssl req -new -key ${SERVER_NAME}.key -out ${SERVER_NAME}.csr

# Self Signed Certificate
echo -e "\nSelf Signed Certificate : ${SERVER_NAME}.crt\n"
openssl x509 -req -in ${SERVER_NAME}.csr -out ${SERVER_NAME}.crt -sha1 -CA ${CA_NAME}.crt -CAkey ${CA_NAME}.key -CAcreateserial -days ${DEFAULT_DAYS:-700}

# Remove Certificate Passphrase
echo -e "\nRemove Certificate Passphrase : ${SERVER_NAME}.insecure.key\n"
openssl rsa -in ${SERVER_NAME}.key -out ${SERVER_NAME}.insecure.key

# Make Privacy Enhanced Mail
echo -e "\nMake Privacy Enhanced Mail : ${SERVER_NAME}.pem\n"
cat ${SERVER_NAME}.crt ${SERVER_NAME}.insecure.key > ${SERVER_NAME}.pem
