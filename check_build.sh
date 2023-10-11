#!/bin/sh

# 로그를 남기는 함수 정의
log_message() {
    # 현재 날짜와 시간 가져오기
    current_time=$(date +"%Y-%m-%d %H:%M:%S")

    # 로그 파일
    log_file="/tmp/build_check.log"

    # 로그 메시지를 로그 파일에 추가
    echo "[$current_time] $@"
    echo "[$current_time] $@" >> "$log_file"
}

log_message "Start"
echo $bamboo_buildResultKey
#buildResultKey="CI2NAC-CN6-C20-4614"
buildResultKey=$bamboo_buildResultKey
echo $buildResultKey
sleep 30
result=$(curl -s -X GET -H "Authorization: Bearer MDU0ODI2NzkwMjAwOvA6RRphw+VRnNHBtbsFHRmWO8Hw"  https://ci2.genians.com/rest/api/latest/result/$buildResultKey | xmllint --xpath 'string(/result/@state)' -)
echo $result

log_message $bamboo_buildResultKey
log_message $buildResultKey
log_message $result

IMAGENAME=$(cat bin/CLOUD/.CLOUD.lastimage | awk -F '/' '{print $7}')
# ISSUE=$(svn log -l1 | grep -o '^GN-[0-9]*'|uniq)
ISSUE="GN-27165" # 테스트 목적 코드
ASSIGNER=$(svn log -l1 | grep -o '| [^ ]* |' | tr -d '|[:space:]')
url="https://ims.genians.com/jira/rest/api/2/issue/$ISSUE"
credentials="tester:tdd321"
content_type="Content-type: application/json"
body=""

statusresponse=$(curl -u tester:tdd321 -X GET https://ims.genians.com/jira/rest/api/2/issue/$ISSUE?fields=status)
status=$(echo $statusresponse | jq -r '.fields.status.name')

echo "Status: $status"
echo "Result: $result"
echo "-----"

if [ "$result" = "Failed" ] || [ "$result" = "" ]; then # 빌드 오류
    echo "build Error"
    echo $IMAGENAME
        echo "Status: $status"
        # 오류 상태 변경
        response=$(curl -X POST -u tester:tdd321 "https://ims.genians.com/jira/rest/api/2/issue/GN-27165/transitions" -H "Content-Type: application/json" --data "{\"transition\": {\"id\": \"301\"}}")

    log_message "jira Status"
    log_message $response


    # 테스트 코드 추후 변경 필요 (In Progress (891) -> Open (301))
    response=$(curl -X POST -u tester:tdd321 "https://ims.genians.com/jira/rest/api/2/issue/GN-27165/comment" -H "Content-type: application/json" --data "{\"body\": \"[자동테스트-빌드 실패함(E1)]\n빌드가 실패했습니다.\n당신과 상관없다면 코멘트남 작성해주시고, 상관 있다면 이전 상태로 변경 후 코드를 수정해 주세요.\n수정 후, Test Request 상태로 변경해 주세요.\n- 빌드번호 : $buildResultKey\"}")

    log_message "jira comment"
    log_message $response

elif [ "$result" = "Unknown" ] && [ "$status" = "In Progress" ]; then # 빌드 성공, 상태가 Test Request(In Progress) 인 경우
    echo "build Ok"
    echo $IMAGENAME
    echo "Status: $status"

        # 테스트 코드 추후 변경 필요 (In Progress (891) -> Open (301))
    response=$(curl -X POST -u tester:tdd321 "https://ims.genians.com/jira/rest/api/2/issue/GN-27165/comment" -H "Content-type: application/json" --data "{\"body\": \"[자동테스트-빌드 성공함(1)]\n빌드 성공하였습니다. 자동 테스트를 시작합
니다.\"}")

    log_message "jira"
    log_message $response

    # Agent 파이프라인 호출
    response=$(curl -X POST -u :vkipeeocyjt7l3eao5mea3qritnbhycan4yk7k6hfjgyimqrcgxa "https://dev.azure.com/Automated-Test/Automated-Test/_apis/pipelines/7/runs?api-version=7.1-preview.1" -H "Content-Type: application/json" -d "{\"stagesToSkip\": [], \"variables\": {\"TESTIMG\": {\"value\": \"$IMAGENAME\"}, \"ISSUE\": {\"value\": \"$ISSUE\"}, \"TEST\": {\"value\": \"$ASSIGNER\"}}}")

    log_message "pipeline"
    log_message $response
fi
