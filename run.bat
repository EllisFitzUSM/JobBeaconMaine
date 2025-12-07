@echo off

echo Building Database

REM For some reason an if/else would double execute. 
IF "%~1"=="--d" (
    echo Building Database Using Specific Arguments User: %~2, Password: %~3
    python backend\createdb.py --user %~2 --pw %~3 --import_data --index

    @echo Running Flask App
    start "Flask Server" python backend/app.py --user %~2 --pw %~3
    goto :frontend
)

echo Building Database Using Defaults (admin, admin)
python backend\createdb.py --import_data --index

@echo Running Flask App
start "Flask Server" python backend/app.py

:frontend

@echo Running Frontend
npm run --prefix frontend/ dev