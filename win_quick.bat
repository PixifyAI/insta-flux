@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: Check if Git is installed
where git >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Git is not installed. Installing Git...
    powershell -Command "Invoke-WebRequest -Uri 'https://git-scm.com/download/win' -OutFile 'git-installer.exe'"
    start /wait git-installer.exe
    del git-installer.exe
)

:: Check if Python is installed
where python >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Python is not installed. Installing Python...
    powershell -Command "Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.10.4/python-3.10.4-amd64.exe' -OutFile 'python-installer.exe'"
    start /wait python-installer.exe
    del python-installer.exe
)

:: Check if pip is installed
python -m pip --version >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Pip is not installed. Installing pip...
    python -m ensurepip
)

:: Clone the repository
echo Cloning repository...
git clone https://github.com/PixifyAI/instaflux-webui
if %ERRORLEVEL% NEQ 0 (
    echo Error: Failed to clone the repository.
    exit /b %ERRORLEVEL%
)

:: Navigate to the project directory
cd insta-flux || exit /b

:: Create a virtual environment
python -m venv venv
if %ERRORLEVEL% NEQ 0 (
    echo Error: Failed to create a virtual environment.
    exit /b %ERRORLEVEL%
)

:: Activate the virtual environment
call venv\Scripts\activate
if %ERRORLEVEL% NEQ 0 (
    echo Error: Failed to activate the virtual environment.
    exit /b %ERRORLEVEL%
)

:: Install the required packages
pip install -r requirements.txt
if %ERRORLEVEL% NEQ 0 (
    echo Error: Failed to install required packages.
    exit /b %ERRORLEVEL%
)
pause

:: Pause to remind the user to add their Runware API key
echo Please add your Runware API key to the InstaFlux.py file then press Enter.
pause

:: Run the script
python InstaFlux.py
if %ERRORLEVEL% NEQ 0 (
    echo Error: Failed to run the application.
    exit /b %ERRORLEVEL%
)
pause
