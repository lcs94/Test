# 현재 할당된 서브넷 대역 가져오기
$subnetAddressPrefixes = @("10.0.0.0/24", "10.0.1.0/25") # Azure CLI 결과에 기반하여 수동으로 입력

# 사용할 대역 범위 초기화
$availablePrefix = "10.0.0.0/24"

# 비어 있는 대역 찾기
foreach ($subnetPrefix in $subnetAddressPrefixes) {
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
