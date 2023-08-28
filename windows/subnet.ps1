# Azure CLI로 서브넷 대역 가져오기
$subnetAddressPrefixes = az network vnet subnet list --resource-group Automated_Test --vnet-name vnet-default --query "[].addressPrefix" --output tsv

# PowerShell에서 배열로 변환
$subnetAddressPrefixesArray = $subnetAddressPrefixes -split "`r`n"

# 사용할 대역 범위 초기화
$availablePrefix = "10.0.0.0/24"

# 비어 있는 대역 찾기
foreach ($subnetPrefix in $subnetAddressPrefixesArray) {
    $subnetPrefix = $subnetPrefix.Trim()
    if ($subnetPrefix -ne $availablePrefix) {
        break
    }

    $subnet = [IPAddress]::Parse($subnetPrefix)
    $subnetEnd = [IPAddress]::Parse($subnetPrefix) + 1

    $availablePrefix = $subnetEnd.ToString()
    
    # "10.0.10.0/24"까지만 확인하도록 변경
    if ($availablePrefix -eq "10.0.10.0/24") {
        break
    }
}

# 선택한 비어 있는 대역을 JSON 파일에 저장
$availablePrefix | ConvertTo-Json | Set-Content -Path "subnet_result.json"
