- name: Set Execution Policy to Bypass
  win_shell: Set-ExecutionPolicy Bypass -Scope Process -Force

- name: Descargar e instalar OpenSSH
  win_shell: |
    $url = "https://github.com/PowerShell/Win32-OpenSSH/releases/download/v8.0.0.0p1-Beta/OpenSSH-Win64.zip"
    $output = "C:\Temp\OpenSSH.zip"
    Invoke-WebRequest -Uri $url -OutFile $output
    Expand-Archive -Path $output -DestinationPath C:\Temp\OpenSSH
    Move-Item -Path C:\Temp\OpenSSH\OpenSSH-Win64 -Destination C:\OpenSSH -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
    Remove-Item -Path $output -Force
    Remove-Item -Path C:\Temp\OpenSSH -Recurse -Force
