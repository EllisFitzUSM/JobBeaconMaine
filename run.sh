#!/bin/bash

DEBUG="--d"
if [[ "$1" == "$DEBUG" ]]; then
    echo "Building database with specific arguments"
    python3 backend/createdb.py --user $2 --pw $3 --import_data --index

    echo Running Flask App
    python3 backend/app.py --user $2 --pw $3 &
else
    echo "Building database with defaults (admin, admin)..."
    python3 backend/createdb.py --import_data --index

    echo Running Flask App
    python3 backend/app.py &
fi

echo Running Frontend
npm run --prefix frontend/ dev