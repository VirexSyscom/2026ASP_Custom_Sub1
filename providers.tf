############################################
# providers.tf（Hub 獨立組態）
#   - required_version：>= 1.9.0
#   - azurerm 鎖在 4.x：~> 4.10
#       * 不可放寬到 5.x（azurerm 5.0 將移除已棄用的 enable_bgp 等參數）
#   - Hub 僅使用 azurerm，不需要 random / azapi
############################################
terraform {
  required_version = ">= 1.9.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.10"
    }
  }
}

# subscription_id 留 null 時，provider 會自動採用 Azure DevOps
# Service Connection 注入的 ARM_SUBSCRIPTION_ID 環境變數。
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
