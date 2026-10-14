############################################
# terraform.tfvars（Hub 獨立組態：Hub-Network-RG）
#
# 部署順序（Hub 與 workloads 為兩個獨立 State）：
#   1. hub-network ：enable_hub_spoke_peering = false → apply（建立 Hub RG 與全部 Hub 資源）
#   2. workloads   ：enable_hub_spoke_peering = false → apply（建立 Spoke / HR / UAT / Migrate）
#   3. hub-network ：改為 true → apply（建立 Hub→Spoke、Hub→UAT Peering）
#   4. workloads   ：改為 true → apply（建立 Spoke→Hub Peering 與 Hub VNet 的 Private DNS 連結）
############################################

############################################
# 訂閱：由 Azure DevOps Service Connection 注入
# ARM_SUBSCRIPTION_ID，一般不需填寫
############################################
# subscription_id = "00000000-0000-0000-0000-000000000000"

############################################
# 命名前綴（須與 workloads 組態一致）
############################################
name_prefix    = "demo"
name_separator = "-"

############################################
# 基本設定（須與 workloads 組態一致）
############################################
location = "japaneast"

############################################
# 資源群組（名稱不套用前綴）
############################################
hub_resource_group_name   = "Hub-Network-RG"
create_hub_resource_group = true

# 僅供查詢 Spoke VNet 使用（須與 workloads 組態的 network_resource_group_name 一致）
network_resource_group_name = "Spoke-Network-RG"

############################################
# 標籤
############################################
environment = "prod"
owner       = "network-team"
cost_center = "CC-1001"

# 全域共用自訂標籤（同名時覆寫系統標籤）
tags = {
  Project      = "Hub-Spoke-Network"
  BusinessUnit = "HR"
  DataClass    = "Confidential"
  Criticality  = "High"
  ReviewDate   = "2027-01-01"
}

# Hub 專屬標籤
hub_tags = {
  Workload = "Hub-Network"
}

############################################
# 網路位址 - Hub
############################################
hub_vnet_address_space      = ["10.0.0.0/16"]
hub_bastion_subnet_prefixes = ["10.0.0.0/26"]
gateway_subnet_prefixes     = ["10.0.1.0/27"]

############################################
# Bastion
############################################
hub_bastion_sku    = "Basic"
create_hub_bastion = true

############################################
# VPN Gateway / Site-to-Site
############################################
create_vpn_gateway          = true
vpn_gateway_sku             = "VpnGw2AZ"
vpn_gateway_public_ip_zones = ["1", "2", "3"]
enable_bgp                  = false

onprem_vpn_public_ip = "203.0.113.10"
onprem_address_spaces = [
  "192.168.10.0/24",
  "192.168.20.0/24"
]

# create_vpn_connection = true 時，vpn_shared_key 必填
# 建議以環境變數注入：TF_VAR_vpn_shared_key
create_vpn_connection = false
# vpn_shared_key      = "***"

############################################
# Hub 與 Spoke 對等互連（Hub 端）
#   首次部署（Spoke 尚未存在）請維持 false；
#   workloads 組態部署完成後改為 true 再 apply。
############################################
enable_hub_spoke_peering = false
