# JSON 형식으로 데이터 생성
$jsonData = @{
    "TESTIMG" = "$(TESTIMG)"
    "ISSUE" = "$(ISSUE)"
    "TEST" = "$(TEST)"
} | ConvertTo-Json

$jsonData | Set-Content -Path "variables_result.json"

$variablesResult = Get-Content -Raw "variables_result.json"

Write-Host "JSON Data: $variablesResult"