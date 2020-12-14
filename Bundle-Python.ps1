
# Prepare Embedded Python
Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.8.6/python-3.8.6-embed-amd64.zip" -OutFile python.zip
Expand-Archive -LiteralPath "python.zip" -DestinationPath "python"
Expand-Archive -LiteralPath "python\python38.zip" -DestinationPath "python\Lib"
Remove-Item "python\python38.zip"
Remove-Item "python\python38._pth"
Remove-Item "python.zip"

# Virtualenv layer
Invoke-WebRequest -Uri "https://bootstrap.pypa.io/get-pip.py" -Out "get-pip.py"
.\python\python.exe "get-pip.py"
.\python\python.exe -m pip install virtualenv

# Virtualenv helper files must be extracted from main python.
# Embedded version does not contain working copy for virtualenv.
Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.8.6/python-3.8.6-amd64.exe" -Out "python-amd64.exe"
.\python-amd64.exe /quiet /passive TargetDir=${pwd}\temp-python3
$InstallerProcess = Get-Process python-amd64.exe
Wait-Process -Id $InstallerProcess.id
mkdir python\Lib\venv\scripts\nt
Copy-Item temp-python3\Lib\venv\scripts\nt\*.exe python\Lib\venv\scripts\nt

# Create final zip
Compress-Archive -Path "python" -DestinationPath "python.zip"
