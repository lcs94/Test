# JSON 형식으로 데이터 생성
$jsonData = @{
    "TESTIMG" = "$(TESTIMG)"
    "ISSUE" = "$(ISSUE)"
    "TEST" = "$(TEST)"
} | ConvertTo-Json

try {
    $jsonData | Set-Content -Path "variables_result.json"
    $variablesResult = Get-Content -Raw "variables_result.json"
    Write-Host "JSON Data: $variablesResult"
} catch {
    Write-Host "Error: $_"  # 오류 메시지 출력
    exit 1  # 오류가 발생하면 스크립트를 종료하고 오류 코드 1을 반환
}