#!/bin/bash

### Info: https://developer.mozilla.org/en-US/docs/Web/HTTP/Public_Key_Pinning

if [ "$#" -eq 0 ] || [ $1 == null ] || [ -z '$1' ]
then
	exit 0;
else
	domain=$1;
fi

if [ "$#" -eq 0 ] || [ $2 == null ] || [ -z '$2' ]
then
	exit 0;
else
	conf_path=$2;
fi

if [ "$#" -eq 0 ] || [ $3 == null ] || [ -z '$3' ]
then
	exit 0;
else
	max_age=$3;
fi

le_dir="/etc/letsencrypt/live";

    chain_cert=$le_dir/$domain/'chain.pem';
fullchain_cert=$le_dir/$domain/'fullchain.pem';

    chain_hash=$(openssl x509 -noout -in $chain_cert -pubkey | openssl rsa -pubin -outform der | openssl dgst -sha256 -binary | base64);
fullchain_hash=$(openssl x509 -noout -in $fullchain_cert -pubkey | openssl rsa -pubin -outform der | openssl dgst -sha256 -binary | base64);

sed -i '/Header set Public-Key-Pins/c\    Header set Public-Key-Pins "pin-sha256=\\"'$fullchain_hash'\\"; pin-sha256=\\"'$chain_hash'\\"; max-age='$max_age'; includeSubDomains"' $conf_path;

service apache2 restart;