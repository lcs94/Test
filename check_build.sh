#!/bin/sh
imgname
IMGNAME=$(cat bin/CT64/.CT64.lastimage | awk -F '/' '{print $7}')
ISSUE=$(svn log -l1 | grep -o 'GN-[0-9]*')

if [ $? -ne 0 ]; then
  echo "build Error"
  echo $IMGNAME
  
  # curl 호출
  response=$(curl -X POST -u :u5pgbr7plfeshhoxs2w4jky2duzeemxfeado72hzfcwuseupmxga "https://dev.azure.com/Automated-Test/Automated-Test/_apis/pipelines/6/runs?api-version=7.1-preview.1" -H "Content-Type: application/json" -d "{\"stagesToSkip\": [], \"variables\": {\"TESTIMG\": {\"value\": \"$IMGNAME\"}, \"ISSUE\": {\"value\": \"$ISSUE\"}, \"TEST\": {\"value\": \"lcs\"}}}")

  echo "Response: $response"
fi

