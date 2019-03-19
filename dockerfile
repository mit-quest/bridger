FROM mcr.microsoft.com/azure-pipelines/vsts-agent:ubuntu-16.04

# Install Google Cloud SDK
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -cs)" \
    && echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" \
        | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
        | apt-key add - \
    && apt-get update -y \
    && apt-get install google-cloud-sdk -y

# Copy the Google Login helper.
COPY ./scripts/g.sh /bridge/scripts/g.sh

# Install Azure CLI
RUN export AZ_REPO=$(lsb_release -cs) \
    && apt-get install -y --no-install-recommends \
        apt-transport-https \
        software-properties-common \
        dirmngr \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" \
        | tee /etc/apt/sources.list.d/azure-cli.list \
    && apt-key --keyring /etc/apt/trusted.gpg.d/Microsoft.gpg adv \
        --keyserver packages.microsoft.com \
        --recv-keys BC528686B50D79E339D3721CEB3E94ADBE1229CF \
    && apt-get update -y \
    && apt-get install -y azure-cli

# Install IBM Cloud CLI
RUN curl -sL https://ibm.biz/idt-installer | bash
