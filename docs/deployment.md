## Deployment: Azure AI Foundry and Dependencies

### **Prerequisites**
Ensure you have the following before deploying the solution:
- ✅ **Azure Subscription:** Active subscription with sufficient privileges to create and manage resources.  
- ✅ **Azure CLI:** Install the [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/get-started-with-azure-cli) for managing Azure resources.  
- ✅ **IDE with Bicep & PowerShell Support:** Use [VS Code](https://code.visualstudio.com/download) with the **Bicep extension** for development and validation.  

---

### **1. Clone the Repository**
Clone the project repository to your local machine:

```bash
git clone https://github.com/jonathanscholtes/azure-ai-network-secure-deployment.git
cd azure-ai-network-secure-deployment
```


### 2. Deploy the Solution  

Use the following PowerShell command to deploy the solution. Be sure to replace the placeholders with your actual subscription name and Azure region.

- The `-DeployVpnGateway` flag is optional and should be used if you need to deploy an Azure VPN Gateway (required when ExpressRoute or an existing VPN is not configured).

```powershell
.\deploy.ps1 -Subscription '[Your Subscription Name]' -Location 'eastus2' -DeployVpnGateway [Optional] 
```

✅ This script provisions all required Azure resources based on the specified parameters. The deployment may take up to **60 minutes** to complete.



### 3. Download the VPN Client  


Once the deployment is complete, follow these steps to download the VPN client:  
- Go to the **Azure Portal** → **Virtual Network Gateway** → **Point-to-Site Configuration**.  
- Click **Download VPN Client**.  
- Extract the file `vgw-foundry-demo-[random].zip`.
- Then import the AzureVPN configuration file `azurevpnconfig.xml` with **Azure VPN Client**




  