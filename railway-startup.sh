bash
    #!/bin/bash
    set -e
    
    echo "=== Hermes Cloud Startup (Railway) ==="
    
    echo "XAI_API_KEY length: ${#XAI_API_KEY}"
    echo "TELEGRAM_BOT_TOKEN length: ${#TELEGRAM_BOT_TOKEN}"
    echo "MODEL_DEFAULT: $MODEL_DEFAULT"
    echo "HERMES_HOME: $HERMES_HOME"
    
    if [ -n "$XAI_API_KEY" ]; then
        echo "XAI_API_KEY=$XAI_API_KEY" >> /root/.hermes/.env
        echo "✓ XAI_API_KEY loaded from Railway Variables"
    else
        echo "⚠ WARNING: XAI_API_KEY is empty!"
    fi
    
    if [ -n "$TELEGRAM_BOT_TOKEN" ]; then
        echo "TELEGRAM_BOT_TOKEN=$TELEGRAM_BOT_TOKEN" >> /root/.hermes/.env
        echo "✓ TELEGRAM_BOT_TOKEN loaded"
    fi
    
    echo "Setting model configuration..."
    hermes config set model.provider xai
    hermes config set model.default grok-4.20-0309-reasoning
    hermes config set model.base_url https://api.x.ai/v1
    
    echo ""
    echo "=== Final Config ==="
    hermes config | grep -E "(model|provider|XAI|key)" || echo "Config command failed"
    
    echo ""
    echo "=== Starting Hermes Gateway ==="
    exec hermes gateway run --replace
