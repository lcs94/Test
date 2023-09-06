$openJdkUrl = "https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_windows-x64_bin.zip"
$downloadDir = "C:\Temp\OpenJDK"
$installDir = "C:\Program Files\OpenJDK"

Invoke-WebRequest -Uri $openJdkUrl -OutFile "openjdk-11.zip"
Expand-Archive -Path "openjdk-11.zip" -DestinationPath $downloadDir
Copy-Item -Path "$downloadDir\*" -Destination $installDir -Recurse

[Environment]::SetEnvironmentVariable('JAVA_HOME', $installDir, [EnvironmentVariableTarget]::Machine)
[Environment]::SetEnvironmentVariable('Path', "$($env:Path);$installDir\bin", [EnvironmentVariableTarget]::Machine)

Remove-Item -Path "openjdk-11.zip" -Force
Remove-Item -Path $downloadDir -Recurse -Force
