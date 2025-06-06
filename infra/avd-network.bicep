// Azure Virtual Desktop用ネットワーク構成のBicepテンプレート例
// 仮想ネットワークとAVD用サブネットを作成します
// 必要に応じてDNSやVPN/ExpressRouteの設定を追加してください

param location string = resourceGroup().location
param vnetName string = 'vnet-avd'
param addressPrefix string = '10.6.0.0/16'
param subnetName string = 'subnet-avd'
param subnetPrefix string = '10.6.1.0/24'

resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [addressPrefix]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
          // 必要に応じてNSGやサービスエンドポイント、Delegation等を追加
        }
      }
    ]
  }
}

// 参考: https://learn.microsoft.com/ja-jp/azure/virtual-desktop/networking
