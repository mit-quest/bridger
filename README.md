# bridger
Bridger is an agent designed to be run in Azure Pipelines Build and Release workflows enabling
the development of _Cross Cloud_ CI/CD pipelines. Built on top of Microsoft's provided Azure
Pipelines Agent, Bridger integrates natively with Azure and provides the additional authentication
mechanisms needed to integrate with other public cloud providers.

## Prerequisites
Bridger is an application deployed to [Kubernetes](http://kubernetes.io) using [Helm](https://helm.sh).
As such, users should have an understanding of how Helm packages and installs software on Kubernetes,
have access to a Kubernetes cluster and have a general understanding of Docker and Kubernetes. Since
Bridger integrates directly with Azure Pipelines, users are expected to have a basic
understanding of Azure Pipelines and have an account in Azure DevOps. Specifically, users should understand
[Build and Release](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/agents)
concepts, and [Agent Pools](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/pools-queues).
Users are also required to have permissions to administer Agent Pools in their associated Azure DevOps
Subscription.

## Deployment
In order to deploy Bridger, a user in Azure DevOps should create a Personal Access Token (PAT)
from within their Azure DevOps account. This user will need to have the permissions to manage
Agent Pools within the Project.

## Getting Started
1. If you are not using Helm, [install it](https://github.com/helm/helm#install).
1. Make sure you have a `kubconfig` that will allow cluster authentication.
1. Create a Service account for Tiller
   ```
   kubectl create serviceaccount --namespace kube-system tiller
   kubectl create clusterrolebinding tiller-cluster-binding \
       --clusterrole=cluster-admin \
       --serviceaccount=kube-system:tiller
   kubectl patch deploy --namespace kube-system tiller-deploy -p \
       '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}
   ```
   **WARNING**  
   You should be aware that this has an effect on the security of your cluster. You can assign greater
   restrictions on Tiller and do not need to assign the cluster role of `cluster-admin` for Tiller to
   work. See more detailed instructions on configuring authentication
   [here](https://github.com/helm/helm/blob/master/docs/rbac.md).


### Creating an Agent Pool in Azure DevOps
1. From Your Azure DevOps organization page, go to Organization Settings  

![Organization Settings](./docs/_static/org_settings.png)

<a href="" id="creating_new_agent_pool"></a>
1. Create a new Agent Pool  
   1. Select Agent Pools
   1. New agent pool...
   1. Provide a name for the new pool in place of `<agent-pool-name>`

![Creating a new Agent Pool in Azure DevOps](./docs/_static/create_agent_pool.png)

### Registering Agents
In order for Bridger to register as an agent in the newly created Agent Pool in Azure DevOps, you will
have to provide the agents with with a minimum of `Agent Pool (Read & manage)` permission levels. To do
thiso generate a PAT by following the directions
[here](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops#create-personal-access-tokens-to-authenticate-access)
and select the correct permissions.
