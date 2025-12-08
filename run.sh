#!/bin/bash

DEBUG="--d"

run_backend_mac() {
    USER_ARG=$1
    PW_ARG=$2
    osascript <<EOF
tell application "Terminal"
    do script "
    source \"$(pwd)/.venv/bin/activate\"
    cd \"$(pwd)/backend\"; python3 app.py $USER_ARG $PW_ARG"
end tell
EOF
}

run_backend_linux() {
    USER_ARG=$1
    PW_ARG=$2

    if command -v gnome-terminal >/dev/null 2>&1; then
        gnome-terminal -- bash -c "cd \"$(pwd)/backend\"; python3 app.py $USER_ARG $PW_ARG; exec bash"
        return
    fi

    if command -v konsole >/dev/null 2>&1; then
        konsole --hold -e bash -c "cd \"$(pwd)/backend\" && python3 app.py $USER_ARG $PW_ARG"
        return
    fi

    echo "No supported terminal emulator found. Backend will run in background."
    python3 backend/app.py $USER_ARG $PW_ARG &
}

run_backend() {
    USER_ARG=$1
    PW_ARG=$2

    OS=$(uname)
    case "$OS" in
        Darwin)
            run_backend_mac "$USER_ARG" "$PW_ARG"
            ;;
        Linux)
            run_backend_linux "$USER_ARG" "$PW_ARG"
            ;;
        *)
            echo "Unsupported OS: $OS. Running backend normally."
            python3 backend/app.py "$USER_ARG" "$PW_ARG" &
            ;;
    esac
}

# -----------------------------
# Main script logic
# -----------------------------

if [[ "$1" == "$DEBUG" ]]; then
    echo "Building database with specific arguments"
    python3 backend/createdb.py --user "$2" --pw "$3" --import_data --index

    echo "Running Flask App in new terminal"
    run_backend "--user $2 --pw $3"
else
    echo "Building database with defaults (admin, admin)..."
    python3 backend/createdb.py --import_data --index

    echo "Running Flask App in new terminal"
    run_backend ""
fi

echo "Running Frontend"
npm run --prefix frontend/ dev
