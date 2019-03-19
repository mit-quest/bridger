#!/bin/bash

set -e

if [[ -z "${GCP_SERVICE_ACCOUNT}" || -z "${GCP_PROJECT}"]]; then
    echo "Expected GCP account information not set." >&2
fi

if [[ -z "${GCP_KEYDATA}" ]]; then
    echo "Expected GCP Service Account Key not set." >&2
fi

gcloud config set project ${GCP_PROJECT}
gcloud config set account ${GCP_SERVICE_ACCOUNT}

echo "${GCP_KEYDATA}" >> keyfile.json
gcloud auth activate-service-account --key-file keyfile.json
