# bridger
Bridger is an agent designed to be run in Azure Pipelines Build and Release workflows enabling
the development of _Cross Cloud_ CI/CD pipelines. Other than native Azure integration, Bridger
integrates with other public cloud providers to enable access to their resources.

## Prerequisites
Bridger is an application deployed to Kubernetes using Helm. As such, users should have an
understanding of how Helm packages and installs software on Kubernetes. Users should have access
to a Kubernetes cluster and have a general understanding of the Kubernetes System.
Since Bridger integrates directly with Azure Pipelines, users are expected to have a basic
understanding of Azure Pipelines and Azure DevOps more generally. Specifically, users should have
worked with Build and Release concepts, including Agent Pools and have the necessary permissions to
administer Agent Pools in their associated Azure DevOps Subscription.
