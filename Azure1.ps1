#Connect-AzAccount -Tenant 'b41b72d0-4e9f-4c26-8a69-f949f367c91d' -SubscriptionId 'd1b4834b-f635-4bdc-b74a-8b4f8a4523f3'
for ($i=1;$i -le 2;$i++)
    {
        $RG = "DenisRG$i"
        New-AzResourceGroup -Name $RG -Location "East US"
        $FESubName = "DenisNet$i"
        $FESubPrefix = "10.$i.0.0/24"
        $GWSubPrefix = "10.$i.255.0/27"
        $fesub = New-AzVirtualNetworkSubnetConfig -Name $FESubName -AddressPrefix $FESubPrefix
        $gwsub = New-AzVirtualNetworkSubnetConfig -Name "GatewaySubnet" -AddressPrefix $GWSubPrefix
        function VirtualNetwork ($VNetName,$RG,$Location,$VNetPrefix,$fesub,$gwsub)
            {
                New-AzVirtualNetwork -Name $VNetName -ResourceGroupName $RG `
                -Location $Location -AddressPrefix $VNetPrefix -Subnet $fesub,$gwsub
            }
        $args = @{
                VNetName = "DenisVNet$i"
                RG = $RG
                Location = "East US"
                VNetPrefix = "10.$i.0.0/16"
                fesub = $fesub
                gwsub = $gwsub
                }
        VirtualNetwork @args -Verbose

        $GWIPName = "VNetGWIP$i"
        $gwpip = New-AzPublicIpAddress -Name $GWIPName -ResourceGroupName $RG `
        -Location "East US" -AllocationMethod Dynamic

        $VNetName = "DenisVNet$i"
        $vnet = Get-AzVirtualNetwork -Name $VNetName -ResourceGroupName $RG
        $subnet = Get-AzVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet
        $GWIPconfName = "gwipconf$i"
        $gwipconf = New-AzVirtualNetworkGatewayIpConfig -Name $GWIPconfName `
        -Subnet $subnet -PublicIpAddress $gwpip
        $GWName = "VNetGW$i"
        New-AzVirtualNetworkGateway -Name $GWName -ResourceGroupName $RG `
        -Location "East US" -IpConfigurations $gwipconf -GatewayType Vpn `
        -VpnType RouteBased -GatewaySku Basic
    }

$vnet1gw = Get-AzVirtualNetworkGateway -Name "VNetGW1" -ResourceGroupName "DenisRG1"
$vnet2gw = Get-AzVirtualNetworkGateway -Name "VNetGW2" -ResourceGroupName "DenisRG2"
    
New-AzVirtualNetworkGatewayConnection -Name "VNet1toVNet2" -ResourceGroupName "DenisRG1" `
-VirtualNetworkGateway1 $vnet1gw -VirtualNetworkGateway2 $vnet2gw -Location "East US" `
-ConnectionType Vnet2Vnet -SharedKey 'AzureA1b2C3'

New-AzVirtualNetworkGatewayConnection -Name "VNet2toVNet1" -ResourceGroupName "DenisRG2" `
-VirtualNetworkGateway1 $vnet2gw -VirtualNetworkGateway2 $vnet1gw -Location "East US" `
-ConnectionType Vnet2Vnet -SharedKey 'AzureA1b2C3' 

