#!/bin/bash

token=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
region=$(curl -H "X-aws-ec2-metadata-token: $token" -v http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
account=$(aws sts get-caller-identity --query Account --output text)

creds=$(aws secretsmanager get-secret-value \
--region $region \
--secret-id ocr-creds \
--query SecretString \
--output text)
username=$(echo $creds | jq -r .username)
password=$(echo $creds | jq -r .password)

set -x

sudo su

docker login -u $username -p $password https://container-registry.oracle.com
docker pull container-registry.oracle.com/middleware/weblogic:12.2.1.4 && docker logout
docker pull ghcr.io/oracle/weblogic-kubernetes-operator:4.0.4
docker pull phx.ocir.io/weblogick8s/quick-start-aux-image:v1
docker pull traefik:v2.9.6

repo=$account.dkr.ecr.$region.amazonaws.com/weblogic

docker tag container-registry.oracle.com/middleware/weblogic:12.2.1.4 $repo:server-12.2.1.4
docker tag ghcr.io/oracle/weblogic-kubernetes-operator:4.0.4 $repo:operator-4.0.4
docker tag phx.ocir.io/weblogick8s/quick-start-aux-image:v1 $repo:aux-v1
docker tag traefik:v2.9.6 $repo:traefik-v2.9.6

aws ecr get-login-password --region $region | \
docker login --username AWS --password-stdin $account.dkr.ecr.$region.amazonaws.com

docker push $repo:server-12.2.1.4
docker push $repo:operator-4.0.4
docker push $repo:aux-v1
docker push $repo:traefik-v2.9.6
