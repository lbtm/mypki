#!/bin/sh

CA_NAME="$1"
DEFAULT_DAYS="$2"

usage() {
        echo "$0 CA_NAME [ DEFAULT_DAYS ]"
        echo "Exemple : $0 myca"
}

[ -z $CA_NAME ] && usage && exit 1

# File conf
#[ -f "vars" ] && . vars

# Make CA private key
echo -e "\nMake CA private key\n"
openssl genrsa -des3 -out ${CA_NAME}.key 2048

# Make CA private certificat
echo -e "\nMake CA private certificat\n"
openssl req -new -x509 -days ${DEFAULT_DAYS:-3650} -key ${CA_NAME}.key -out ${CA_NAME}.crt
