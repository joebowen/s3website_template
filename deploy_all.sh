#!/bin/bash

WEBSITE_NAME='test-site'
STAGE='dev'
PROFILE='default'
DOMAIN_NAME='s3websitetestsite.com'
AWS_DEFAULT_REGION='us-west-2'

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --website-name)
    WEBSITE_NAME="$2"
    shift # past argument
    shift # past value
    ;;
    --stage)
    STAGE="$2"
    shift # past argument
    shift # past value
    ;;
    --profile)
    PROFILE="$2"
    shift # past argument
    shift # past value
    ;;
    --domain-name)
    DOMAIN_NAME="$2"
    shift # past argument
    shift # past value
    ;;
    --aws-region)
    AWS_DEFAULT_REGION="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}"

AWS_PROFILE=${PROFILE} aws cloudformation deploy --template-file resources/s3_bucket.yaml --stack-name ${WEBSITE_NAME}-${STAGE} --parameter-overrides RootDomainName=${DOMAIN_NAME}

(cd website && npm install)
(cd website && npm update)
(cd website && gulp)

AWS_PROFILE=${PROFILE} aws s3 sync website/ s3://${DOMAIN_NAME}/ --exclude "*node_modules/*"