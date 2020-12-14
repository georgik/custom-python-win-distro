
param (
    [string]$PythonVersion="3.8.6"
)

# Creates custom build of Python Embedded and apply changes so that it works with virtualenv

# Transform version name to short form used in file names 3.8.6 -> 38
$VersionItems = $PythonVersion.Split(".")
$ShortPythonVersion = $VersionItems[0] + $VersionItems[1]
$PythonDirectory = "Python${ShortPythonVersion}"

# Prepare Embedded Python
Invoke-WebRequest -Uri "https://www.python.org/ftp/python/${PythonVersion}/python-${PythonVersion}-embed-amd64.zip" -OutFile python.zip
Expand-Archive -LiteralPath "python.zip" -DestinationPath "${PythonDirectory}"
Expand-Archive -LiteralPath "${PythonDirectory}\python${ShortPythonVersion}.zip" -DestinationPath "${PythonDirectory}\Lib"
Remove-Item "${PythonDirectory}\python${ShortPythonVersion}.zip"
Remove-Item "${PythonDirectory}\python${ShortPythonVersion}._pth"
Remove-Item "python.zip"

# Virtualenv layer
Invoke-WebRequest -Uri "https://bootstrap.pypa.io/get-pip.py" -Out "get-pip.py"
.\python\python.exe "get-pip.py"
.\python\python.exe -m pip install virtualenv

# Virtualenv helper files must be extracted from main python.
# Embedded version does not contain working copy for virtualenv.
Invoke-WebRequest -Uri "https://www.python.org/ftp/python/${PythonVersion}/python-${PythonVersion}-amd64.exe" -Out "python-amd64.exe"
.\python-amd64.exe /quiet /passive TargetDir=${pwd}\temp-python3
$InstallerProcess = Get-Process python-amd64
Wait-Process -Id $InstallerProcess.id
mkdir python\Lib\venv\scripts\nt
Copy-Item temp-python3\Lib\venv\scripts\nt\*.exe ${PythonDirectory}\Lib\venv\scripts\nt

# Create final zip - GitHub performs compression of artifacts automatically
#Compress-Archive -Path "python" -DestinationPath "python.zip"
