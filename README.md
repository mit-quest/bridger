# bridger
Bridger is an agent designed to be run in Azure Pipelines Build and Release workflows enabling
the development of _Cross Cloud_ CI/CD pipelines. Built on top of Microsoft's provided Azure
Pipelines Agent, Bridger integrates natively with Azure and provides the additional authentication
mechanisms needed to integrate with other public cloud providers.

## Prerequisites
Bridger is an application deployed to [Kubernetes](http://kubernetes.io) using [Helm](https://helm.sh).
As such, users should have an understanding of how Helm packages and installs software on Kubernetes,
have access to a Kubernetes cluster, and have a general understanding of Docker and Kubernetes. Since
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
   <span style="color:red">**WARNING**</span>  
   You should be aware that this has an effect on the security of your cluster. You can assign greater
   restrictions on Tiller and do not need to assign the cluster role of `cluster-admin` for Tiller to
   work. See more detailed instructions on configuring authentication
   [here](https://github.com/helm/helm/blob/master/docs/rbac.md).


### Creating an Agent Pool in Azure DevOps
1. From Your Azure DevOps organization page, go to Organization Settings  

![Organization Settings](./docs/_static/org_settings.png)

<a href="" id="creating_new_agent_pool"></a>
2. Create a new Agent Pool  
   1. Select Agent Pools
   1. New agent pool...
   1. Provide a name for the new pool in place of `<agent-pool-name>`

![Creating a new Agent Pool in Azure DevOps](./docs/_static/create_agent_pool.png)

<a href="" id="generating_agent_pat"></a>
### Generating Agent Authentication Token
In order for Bridger to register as an agent in the newly created Agent Pool, you will
have to provide the agents with with a minimum of `Agent Pool (Read & manage)` permission levels. To do
this generate a PAT in Azure DevOps by following the directions
[here](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops#create-personal-access-tokens-to-authenticate-access)
and select the associated permissions.

After creating the PAT, make sure and store it in a secure location as it will be used later in the
deployment process.

-----

**NOTE**  
You may want to select additional permissions for your agents depending on what resources you
wish to connect to in your CI/CD pipeline. The permissions listed here are the **_bare minimum_**
set of permissions required to register the agents with Azure DevOps.

----

### Configuring values.yaml
The provided [values.yaml](./helm/bridge-agent) for Bridger need to be modified in order to complete
a minimally viable deployment to your Kubernetes cluster. You will need:

1. Your Azure DevOps Organization/Account name.  
   The name can be found in the URL of your Azure DevOps Organization Page. Use the `<account>` section
   from one of the following URLs (whichever is present)  
   `https://<acount>.visualstudio.com`  
   `https://dev.azure.com/<account>`

2. The Name of the agent pool.  
   This is the same name you used when [creating the new agent pool](#create_new_agent_pool)

3. A PAT with `Agent Pool (Read & manage)` permissions.  
   Use the same PAT [generated above](#generating_agent_pat)

### Connecting to GCP.
The Helm chart also provides a set of values you can use to connect your build nd release agents to 
Google Cloud resources.

1. Create a Service Account For Bridger Agents to Connet to GCP Resources.  
   e.g.  
   ```
   gcloud iam service-accounts create azure-pipelines-agent \
       --display-name "Azure Pipelines Bridger Agent"

   _SERVICE_ACCOUNT=$(gcloud iam service-accounts list \
       --filter="displayName:Azure Pipelines Bridger Agent" \
       --format="value(email)")
   ```

2. Add Role Bindings to give the Azure Pipelines agent permissions to manage build or deployment
   phases on GCP resources.
   ```
   gcloud projects add-iam-policy-binding <GCLOUD_PROJECT_NAME> \
       --member serviceAccount:$_SERVICE_ACCOUNT \
       --roles <roles>
   ```
   **NOTE**  
   The roles chosen depend on the amount of resources Bridger Agents should have access to within GCP.
   This may include the need to create and manage other projects, manage deployments to Compute Engine,
   Cloud Functions, App Engine and other resources. As a best practive, you should assign the minimal
   number of roles needed for Bridger to access just the resources it needs to manage within GCP.

3. Generate a service account key.
   1. Run the gcloud command to gnerate a JSON file containing the key.
      ```
      gcloud iam service-accounts keys create azure-pipelines-agent.json \
          --iam-account $_SERVICE_ACCOUNT
      ```
   2. Save the file in bridger's helm chart directory root:  
      If the service account key was screated using cloudshell, you may be able to retrieve it
      using the following command.
      ```
      gcloud alpha cloud-shell scp \
          cloudshell:~/aure-pipelines-agent.json \
          localhost:<path-to-repo>/bridger/helm/bridge-agent/azure-pipelines-agent.json
      ```
      Otherwise, just move the generated JSON file to the path outlined above.

4. Modify values.yaml to connect to GCP
   1. add the service account name
      ```
      gcp:
        account: azure-pipelines-agent
        ...
      ```
   2. add the project name
      ```
        project: <GCLOUD_PROJECT_NAME>
      ```
   3. add the filename of the service account key
      ```
      secrets:
        ...
        gcpServiceAccountKeyfile: azure-pipelines-agent.json
      ```

5. Make Sure the formatting of the service account key file is properly escaped.  
   Within the azure-pipelines-agent.json file, modify the `"private_key"` value such that all
   occurrances of `\n` appear as `\\n`:  
   e.g.  
   ```
   ...
   \\nNpvYkUplAgMBAAECggEAKfuRvct4fR6iuyBLrd8Sr+B3nujIMyLcaOXP5bl/kVf3\\nJq+L5muWY/lntS9p
   ...
   ```
