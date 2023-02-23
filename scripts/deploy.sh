#!/bin/bash

domain=$(aws secretsmanager get-secret-value \
--region us-east-1 \
--secret-id domain \
--query SecretString \
--output text)
export USERNAME=$(echo $domain | jq -r .username)
export PASSWORD=$(echo $domain | jq -r .password)
export ENCRYPTION=$(echo $domain | jq -r .encryption)

set -x

cdk deploy --all
 
 set +x