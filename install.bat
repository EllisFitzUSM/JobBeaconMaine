@echo off

echo "Creating Virtual Environment..."
SET VENV_DIR=.venv
IF "!" "-d" "%VENV_DIR%" (
  echo "Virtual environment '%VENV_DIR%' not found. Creating..."
  python3 "-m" "venv" "%VENV_DIR%"
  echo "Virtual environment '%VENV_DIR%' created successfully."
) ELSE (
  echo "Virtual environment '%VENV_DIR%' already exists."
)
echo "Installing dependencies..."
pip "install" "-r" "requirements.txt"
SET DEBUG=--d
IF [[ "%~1" == "%DEBUG%" ]] (
  echo "Building database with specific arguments"
  python "backend\createdb.py" "--user" "%~2" "--pw" "%~3" "--import_data" "--index"
) ELSE (
  echo "Building database with defaults (admin, admin)..."
  python "backend\createdb.py" "--import_data" "--index"
)