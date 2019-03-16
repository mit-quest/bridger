FROM mcr.microsoft.com/azure-pipelines/vsts-agent:ubuntu-16.04

# Install Google Cloud SDK
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -cs)" \
    && echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" \
        | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
        | apt-key add - \
    && apt-get update -y \
    && apt-get install google-cloud-sdk -y
