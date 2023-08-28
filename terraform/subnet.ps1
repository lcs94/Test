# Azure CLI로 서브넷 대역 가져오기
$subnetAddressPrefixes = az network vnet subnet list --resource-group Automated_Test --vnet-name vnet-default --query "[].addressPrefix" --output tsv

# PowerShell 배열로 변환
$subnetAddressPrefixesArray = $subnetAddressPrefixes -split "`r`n"

# 사용 가능한 대역 범위 초기화
$availablePrefixes = @(
    "10.0.0.0/24",
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24",
    "10.0.7.0/24",
    "10.0.8.0/24",
    "10.0.9.0/24",
    "10.0.10.0/24"
)

# 이미 사용 중인 대역을 모두 가져오기
$usedSubnets = $subnetAddressPrefixesArray | ForEach-Object { $_.Trim() }

# 사용 가능한 대역 중에서 이미 사용 중인 대역 제외
$unusedPrefixes = $availablePrefixes | Where-Object { $_ -notin $usedSubnets }

# 하나의 대역만 선택
$unusedPrefix = $unusedPrefixes[0]

# subnet_result.json 파일에 사용 가능한 대역 저장
$unusedPrefix | Set-Content -Path "subnet_result.json"

# JSON 파일에서 값을 읽어옴
$subnetResult = Get-Content -Raw "subnet_result.json"

# 값을 출력
Write-Host "Unused Subnet: $subnetResult"
