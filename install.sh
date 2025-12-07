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

echo "Activating Virtual Environment..."
source "$VENV_DIR/bin/activate"

echo "Installing dependencies..."
pip install -r requirements.txt

echo Install Node Modules
npm --prefix frontend/ install