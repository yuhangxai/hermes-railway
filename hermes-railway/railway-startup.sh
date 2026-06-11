#!/bin/bash
set -e

echo "=== Hermes Railway Deployment $(date) ==="

# Load Railway variables into .env
if [ -n "$XAI_API_KEY" ]; then
    echo "XAI_API_KEY=$XAI_API_KEY" > /root/.hermes/.env
    echo "✓ XAI_API_KEY loaded"
fi

if [ -n "$TELEGRAM_BOT_TOKEN" ]; then
    echo "TELEGRAM_BOT_TOKEN=$TELEGRAM_BOT_TOKEN" >> /root/.hermes/.env
    echo "✓ TELEGRAM_BOT_TOKEN loaded"
fi

# Set user ID allowlist
echo "TELEGRAM_ALLOWED_USERS=5682076755" >> /root/.hermes/.env
echo "GATEWAY_ALLOW_ALL_USERS=false" >> /root/.hermes/.env

# Configure model
hermes config set model.provider xai
hermes config set model.default grok-4.20-0309-reasoning

echo "=== Config Check ==="
hermes config check | tail -10

echo "=== Starting Gateway ==="
exec hermes gateway run --replace
