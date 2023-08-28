# Azure CLI로 서브넷 대역 가져오기
$subnetAddressPrefixes = az network vnet subnet list --resource-group Automated_Test --vnet-name vnet-default --query "[].addressPrefix" --output tsv

# PowerShell에서 배열로 변환
$subnetAddressPrefixesArray = $subnetAddressPrefixes -split "`r`n"

# 사용할 대역 범위 초기화
$availablePrefix = "10.0.0.0/24"

if ($subnetAddressPrefixesArray.Length -eq 0) {
    Write-Host "No subnet prefixes found. Adding default value..."
    $subnetAddressPrefixesArray += "10.0.0.0/24"
}

# 비어 있는 대역 찾기
foreach ($subnetPrefix in $subnetAddressPrefixesArray) {
    $subnetPrefix = $subnetPrefix.Trim()
    
    # IP 주소 파싱 시도
    try {
        $subnet = [IPAddress]::Parse($subnetPrefix)
    }
    catch {
        Write-Host "Invalid IP address: $subnetPrefix. Skipping..."
        continue
    }
}

# 선택한 비어 있는 대역을 JSON 파일에 저장
$availablePrefix | ConvertTo-Json | Set-Content -Path "subnet_result.json"

# JSON 파일에서 값을 읽어옴
$subnetResult = Get-Content -Raw "subnet_result.json" | ConvertFrom-Json

# 값을 출력
Write-Host "Subnet Result: $subnetResult"