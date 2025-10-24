#!/bin/bash
# setup_testing_venv.sh — Create test_venv and link alias to ~/tests

echo "[SETUP] Creating ~/venvs and ~/tests directories..."
mkdir -p ~/venvs
mkdir -p ~/tests

echo "[SETUP] Creating virtual environment: test_venv"
python3 -m venv ~/venvs/test_venv

echo "[SETUP] Adding alias to ~/.bashrc"
ALIAS_LINE="alias testvenv='source ~/venvs/test_venv/bin/activate && cd ~/tests'"
if ! grep -Fxq "$ALIAS_LINE" ~/.bashrc; then
    echo "$ALIAS_LINE" >> ~/.bashrc
    echo "[SETUP] Alias added to .bashrc"
else
    echo "[INFO] Alias already exists in .bashrc"
fi

echo "[SETUP] Adding login message to ~/.bashrc"
LOGIN_MARKER="# >>> testvenv login message >>>"
if ! grep -Fxq "$LOGIN_MARKER" ~/.bashrc; then
    cat << 'EOF' >> ~/.bashrc

# >>> testvenv login message >>>
function show_testvenv_info() {
    local CYAN='\033[0;36m'
    local NC='\033[0m'  # No Color
    echo -e "\n${CYAN}Test Virtual Environment:${NC} testvenv\n"
}
PROMPT_COMMAND="show_testvenv_info"
# <<< testvenv login message <<<
EOF
    echo "[SETUP] Login message added to .bashrc"
else
    echo "[INFO] Login message already present in .bashrc"
fi

echo "[SETUP] Reloading .bashrc"
source ~/.bashrc

echo "[DONE] You can now run: testvenv"