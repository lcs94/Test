curl -X POST -u :bcwdty4awna54fzgwrbozljtcerxtzvkpqvaf5avazi3bcv3t6tq "https://dev.azure.com/Automated-Test/Automated-Test/_apis/pipelines/4/runs?api-version=7.1-preview.1" -H "Content-Type: application/json" -d "{\"stagesToSkip\": [], \"templateParameters\": {\"customParameter1\": \"GN-26495\", \"customParameter2\": \"NAC-CT64-R-119158-5.0.55.0830.img\", \"customParameter3\": \"lcs\"}}"