#!/bin/bash

set -e

if [ -z "${GCP_SERVICE_ACCOUNT}" ]; then
    echo "GCP Service Account required" >&2
fi

if [ -z "${GCP_PROJECT}" ]; then
    echo "GCP Project required." >&2
fi

if [ -z "${GCP_KEYDATA}" ]; then
    echo "GCP Service Account Key required." >&2
fi

gcloud config set project ${GCP_PROJECT}
gcloud config set account ${GCP_SERVICE_ACCOUNT}

echo "${GCP_KEYDATA}" >> keyfile.json
gcloud auth activate-service-account --key-file keyfile.json
