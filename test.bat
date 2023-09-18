set TEST_RUN_LOG=C:\test_run_%date:~0,7%.txt
echo %TEST_RUN_LOG%

echo ====================================================================== >> %TEST_RUN_LOG%
echo %date%, %Time% >> %TEST_RUN_LOG%

set TESTIMG=%1
set ISSUE=%2
set TEST=%3
set Agent=%4
set dkns=%5

cmd /k "cd C:\CLOUD\test\v6 && mvn compile %% java -cp target/classes com.genians.TestRun %1 %2 %3 %4 %5 >> %TEST_RUN_LOG%
