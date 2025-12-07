@echo off
echo Creating Virtual Environment...

set "VENV_DIR=.venv"

IF NOT EXIST "%VENV_DIR%" (
    echo Virtual environment '%VENV_DIR%' not found. Creating new one
    python -m venv "%VENV_DIR%"
    echo Virtual environment '%VENV_DIR%' created successfully
) ELSE (
    echo Virtual environment '%VENV_DIR%' already exists
)

CALL "%VENV_DIR%\Scripts\activate.bat"

echo Installing Python Libraries
pip install -r requirements.txt

@echo Installing Node Modules
npm --prefix frontend/ install