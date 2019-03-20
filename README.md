# bridger
Bridger is an agent designed to be run in Azure Pipelines Build and Release workflows enabling
the development of _Cross Cloud_ CI/CD pipelines. Other than native Azure integration, Bridger
integrates with other public cloud providers to enable access to their resources.

## Prerequisites
Bridger is an application deployed to Kubernetes using Helm. As such, users should have an
understanding of how Helm packages and installs software to Kubernetes and should have gone
through the setup steps to begin using a Kubernetes. Additionally, Bridger integrates
directly with Azure Pipelines and users housl have a basic understanding of Azure Pipelines
Build and Release concepts, Agent Pools and have the necessary permissions to administer
Agent Pools in their associated Azure DevOps Subscription.
