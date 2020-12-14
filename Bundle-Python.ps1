
# Prepare Embedded Python
Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.8.6/python-3.8.6-embed-amd64.zip" -OutFile python.zip
Expand-Archive -LiteralPath "python.zip" -DestinationPath "C:\Temp\python"
Expand-Archive -LiteralPath "C:\Temp\python\python38.zip" -DestinationPath "C:\Temp\python\Lib"
Remove-Item "C:\Temp\python\python38.zip"
Remove-Item "C:\Temp\python\python38._pth"
Remove-Item "C:\Temp\python.zip"

# Virtualenv layer
Invoke-WebRequest -Uri "https://bootstrap.pypa.io/get-pip.py" -Out "C:\Temp\get-pip.py"
C:\Temp\python\python.exe "C:\Temp\get-pip.py"
C:\Temp\python\python.exe -m pip install virtualenv

# Virtualenv helper files must be extracted from main python.
# Embedded version does not contain working copy for virtualenv.
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install python3 -Y --version=3.8.6
mkdir C:\Temp\python\Lib\venv\scripts\nt
Copy-Item C:\Python38\Lib\venv\scripts\nt\*.exe C:\Temp\python\Lib\venv\scripts\nt

# Create final zip
Compress-Archive -Path "python" -DestinationPath "C:\Temp\python.zip"