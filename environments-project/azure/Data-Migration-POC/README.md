# Data-Migration-POC Environment (for_each Driven)

This environment provisions the complete testing infrastructure for an automated data migration pipeline from a **Source SQL Server Instance** to destination **Azure SQL Managed Instances (MI)** on the same VNet and Subnet, fully powered by **`for_each`** map structures for maximal flexibility and least-cost optimization.

---

## Architecture Overview

```
                      +-------------------------------------------------------------+
                      |               VNet: 10.0.0.0/16 (East US 2)                 |
                      |                                                             |
                      |  +---------------------+   +-----------------------------+  |
                      |  | Subnet: 10.0.2.0/28 |   | Subnet: 10.0.1.0/26         |  |
                      |  | (Source SQL VM)     |   | (Delegated to MI - 64 IPs)  |  |
                      |  |                     |   |                             |  |
                      |  | [SQL Server 2022    |   | [Azure SQL MI (Primary)]    |  |
                      |  |   Developer VM]     |   | (GP_Gen5, 4 vCore, 32GB)    |  |
                      |  |   (Standard_B2s,    |   |                             |  |
                      |  |    32GB OS Disk)    |   |                             |  |
                      |  +----------+----------+   +--------------+--------------+  |
                      +-------------|-----------------------------|-----------------+
                                    |                             |
                                    v                             v
                           +-----------------------------------------+
                           |   Azure Storage Account (Standard LRS)  |
                           |      Container: 'migration-backups'     |
                           |       (Native BACKUP & RESTORE URL)     |
                           +-----------------------------------------+
```

---

## All Resources Provisioned via `for_each`

| Resource Category | Configuration Pattern | Key Benefits |
| :--- | :--- | :--- |
| **Subnets** | `azurerm_subnet.subnets` | Map-driven with dynamic `delegation` block |
| **Route Tables & Associations** | `azurerm_route_table.route_tables` | Dynamically associated to subnets via `route_table_key` |
| **NSGs & Rules** | `azurerm_network_security_group.nsgs` | Dynamic security rules per NSG, mapped via `nsg_key` |
| **SQL Managed Instances** | `module.sql_managed_instance` | Provision 1, 2, or N MIs on the same subnet without code duplication |
| **Storage Accounts & Blobs** | `module.storage_accounts` | Configurable containers and replication via map |
| **Source VMs & NICs** | `azurerm_windows_virtual_machine.vms` | Automated NIC creation and VM attachment |

---

## Minimum Resource Specifications (Least Cost)

| Component | Minimum Specification | Azure Minimum Rationale |
| :--- | :--- | :--- |
| **Resource Group** | `Data-Migration-POC` | Dedicated resource group for POC |
| **Destination MI SKU** | `GP_Gen5` (General Purpose) | Lowest tier available for SQL Managed Instance |
| **MI vCores (Each)** | `4 vCores` | Azure minimum possible for Managed Instance |
| **MI Storage (Each)** | `32 GB` | Azure minimum possible for GP_Gen5 |
| **MI Storage Account Type** | `LRS` | Lowest cost redundancy |
| **MI Subnet Mask** | `/26` (64 IP addresses) | Minimum recommended subnet size to host multiple MIs without IP exhaustion |
| **Source Subnet Mask** | `/28` (16 IP addresses) | Minimal subnet for source VM |
| **Source VM Size** | `Standard_B2s` | Burstable 2 vCPU / 4GB RAM with free SQL Developer Edition |
| **Source VM OS Disk** | `32 GB Standard_LRS` | Minimum OS disk size and lowest cost HDD tier |
| **Migration Storage** | `Standard_LRS` | Minimal cost Blob storage for backup `.bak` files |

---

## Applied Tags (Referencing `rg-ai-dev-eus2-001`)

- **Requested By / Requester**: `Ganeswar.Pasalapudi@programmers.ai`
- **Approved By**: `smitesh.mane@programmers.ai`
- **CreatedBy**: `Yogesh.pathe@programmers.ai`
- **ManagedBy**: `IT-solutions@programmers.ai`
- **ReviewDate**: `12/31/2026`
- **Environment**: `dev`
- **Project**: `Data-Migration-POC`

---

## Sensitive Variables & GitHub Secrets Management

All passwords and sensitive cloud credentials have been removed from `terraform.tfvars`. Configure them as GitHub Secrets / Environment variables using standard Terraform environment prefixes:

| GitHub Secret Name | Mapped Environment Variable | Description |
| :--- | :--- | :--- |
| `MI_ADMIN_PASSWORD` | `TF_VAR_default_mi_administrator_login_password` | Master SQL Admin password for Azure SQL Managed Instances |
| `VM_ADMIN_PASSWORD` | `TF_VAR_default_vm_admin_password` | Local administrator password for source SQL Virtual Machines |
| `AZURE_SUBSCRIPTION_ID` | `ARM_SUBSCRIPTION_ID` | Azure Subscription ID |
| `AZURE_TENANT_ID` | `ARM_TENANT_ID` | Azure Active Directory Tenant ID |
| `AZURE_CLIENT_ID` | `ARM_CLIENT_ID` | Azure Service Principal App ID |
| `AZURE_CLIENT_SECRET` | `ARM_CLIENT_SECRET` | Azure Service Principal Secret |

### Local Testing with Environment Variables
When running locally or via WSL, export the variables in your terminal:
```bash
export TF_VAR_default_mi_administrator_login_password="YourStrongPassword123!"
export TF_VAR_default_vm_admin_password="YourStrongPassword123!"
```

---

## Remote State Backend

The Terraform state file is stored in Azure Blob Storage:
- **Resource Group**: `Data-Migration-POC`
- **Storage Account**: `datamigpoc8`
- **Container**: `tfstate`
- **State Key**: `data-migration-poc.terraform.tfstate`

If the container `tfstate` is not yet created in `datamigpoc8`, create it with:
```bash
az storage container create --name tfstate --account-name datamigpoc8 --auth-mode login
```

---

## Deployment Steps

1. **Initialize Terraform**:
   ```bash
   cd environments-project/azure/Data-Migration-POC
   terraform init
   ```

2. **Review Plan**:
   ```bash
   terraform plan
   ```

3. **Apply Configuration**:
   ```bash
   terraform apply
   ```
