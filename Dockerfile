dockerfile
    FROM python:3.11-slim
    
    RUN apt-get update && apt-get install -y curl git xz-utils && rm -rf /var/lib/apt/lists/*
    
    RUN curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
    
    ENV HERMES_HOME=/root/.hermes \
        HERMES_YOLO_MODE=1
    
    WORKDIR /root
    RUN mkdir -p /root/.hermes
    
    CMD bash -c '
        echo "=== ENVIRONMENT DEBUG ==="
        env | grep -E "XAI|API_KEY|TELEGRAM|MODEL|HERMES" | sort
        echo "XAI_API_KEY length: ${#XAI_API_KEY}"
        echo ""
        echo "=== Writing keys to .env ==="
        echo "XAI_API_KEY=*** > /root/.hermes/.env
        echo "TELEGRAM_BOT_TOKEN=***" >> /root/.hermes/.env
        cat /root/.hermes/.env
        echo ""
        echo "=== Running hermes config ==="
        hermes config set model.provider xai
        hermes config set model.default grok-4.20-0309-reasoning
        hermes config
        echo ""
        echo "=== Starting Gateway ==="
        exec hermes gateway run --replace
    '
