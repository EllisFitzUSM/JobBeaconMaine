#!/bin/bash

echo "Creating Virtual Environment..."
VENV_DIR=".venv"

if [ ! -d "$VENV_DIR" ]; then
    echo "Virtual environment '$VENV_DIR' not found. Creating..."
    python3 -m venv "$VENV_DIR"
    echo "Virtual environment '$VENV_DIR' created successfully."
else
    echo "Virtual environment '$VENV_DIR' already exists."
fi

echo "Installing dependencies..."
pip install -r requirements.txt

DEBUG="--d"
if [[ "$1" == "$DEBUG" ]]; then
    echo "Building database with specific arguments"
    python backend/createdb.py --user $2 --pw $3 --import_data --index
else
    echo "Building database with defaults (admin, admin)..."
    python backend/createdb.py --import_data --index
fi