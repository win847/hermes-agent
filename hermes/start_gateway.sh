#!/bin/bash
# Start Hermes Gateway with QQBot configuration

# Activate the virtual environment
source /workspace/hermes/code/venv/bin/activate

# Load environment variables from .env
if [ -f /workspace/hermes/config/.env ]; then
    echo "Loading environment from /workspace/hermes/config/.env"
    export $(grep -v '^#' /workspace/hermes/config/.env | xargs -d '\n')
fi

# Verify QQBot configuration is loaded
echo "QQ_APP_ID: ${QQ_APP_ID:-not set}"
echo "QQ_CLIENT_SECRET: ${QQ_CLIENT_SECRET:+set}"

# Start the gateway
echo "Starting Hermes Gateway..."
hermes gateway run
