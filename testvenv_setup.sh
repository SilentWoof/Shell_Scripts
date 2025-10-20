#!/bin/bash
# setup_testing_venv.sh — Create testing_venv and link alias to ~/tests

echo "[SETUP] Creating ~/venvs and ~/tests directories..."
mkdir -p ~/venvs
mkdir -p ~/tests

echo "[SETUP] Creating virtual environment: testing_venv"
python3 -m venv ~/venvs/testing_venv

echo "[SETUP] Adding alias to ~/.bashrc"
ALIAS_LINE="alias testvenv='source ~/venvs/testing_venv/bin/activate && cd ~/tests'"
if ! grep -Fxq "$ALIAS_LINE" ~/.bashrc; then
    echo "$ALIAS_LINE" >> ~/.bashrc
    echo "[SETUP] Alias added to .bashrc"
else
    echo "[INFO] Alias already exists in .bashrc"
fi

echo "[SETUP] Reloading .bashrc"
source ~/.bashrc

echo "[DONE] You can now run: testvenv"