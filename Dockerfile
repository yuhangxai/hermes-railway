dockerfile
    FROM python:3.11-slim
    
    LABEL maintainer="Hermes Agent" description="Simple Hermes Gateway for Railway" version="2.2-simple"
    
    RUN apt-get update && apt-get install -y curl git xz-utils ca-certificates && rm -rf /var/lib/apt/lists/*
    
    RUN curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
    
    ENV HERMES_HOME=/root/.hermes \
        HERMES_YOLO_MODE=1 \
        PYTHONUNBUFFERED=1 \
        MODEL_DEFAULT=grok-4.20-0309-reasoning \
        MODEL_PROVIDER=xai
    
    WORKDIR /root
    RUN mkdir -p /root/.hermes/logs /root/.hermes/sessions
    
    关键调试逻辑：直接在启动时写入密钥并设置模型
    CMD bash -c '
        echo "=== Railway Startup Debug ==="
        echo "XAI_API_KEY length: ${#XAI_API_KEY}"
        if [ -n "$XAI_API_KEY" ]; then
          echo "XAI_API_KEY=$XAI_API_KEY" >> /root/.hermes/.env
          echo "✓ XAI_API_KEY loaded successfully"
        else
          echo "✗ XAI_API_KEY is missing or empty!"
        fi
        if [ -n "$TELEGRAM_BOT_TOKEN" ]; then
          echo "TELEGRAM_BOT_TOKEN=***" >> /root/.hermes/.env
          echo "✓ TELEGRAM_BOT_TOKEN loaded"
        fi
        echo "Setting model config..."
        hermes config set model.provider xai
        hermes config set model.default grok-4.20-0309-reasoning
        hermes config set model.base_url https://api.x.ai/v1
        echo "=== Final Config ==="
        hermes config | grep -E "(model|provider|XAI)"
        echo "=== Starting Hermes Gateway ==="
        exec hermes gateway run --replace
    '
