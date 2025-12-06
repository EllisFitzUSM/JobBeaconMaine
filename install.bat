@echo off
echo Creating Virtual Environment...

set "VENV_DIR=.venv"

IF NOT EXIST "%VENV_DIR%" (
    echo Virtual environment '%VENV_DIR%' not found. Creating...
    python -m venv "%VENV_DIR%"
    echo Virtual environment '%VENV_DIR%' created successfully.
) ELSE (
    echo Virtual environment '%VENV_DIR%' already exists.
)

CALL "%VENV_DIR%\Scripts\activate.bat"

echo Installing dependencies
pip install -r requirements.txt

echo Building database

IF "%~1"=="--d" (
    echo Using specific arguments user %~2 and password %~3
    python backend\createdb.py --user %~2 --pw %~3 --import_data --index
    goto :end
)

echo Using defaults (admin, admin)
python backend\createdb.py --import_data --index

:end