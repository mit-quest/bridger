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

## Getting Started
In order to deploy Bridger, a user in Azure DevOps should create a Personal Access Token (PAT)
from within their Azure DevOps account. This user will need to have the permissions to manage
Agent Pools within the Project.

### Creating an Agent Pool in Azure DevOps
1. From Your Azure DevOps organization page, go to Organization Settings  
![Organization Settings](./docs/_static/org_settings.png)
1. Select Agent Pools
1. New agent pool...
1. Provide a name for the new pool in place of `<agent-pool-name>`  
![Creating a new Agent Pool in Azure DevOps](./docs/_static/create_agent_pool.png)
