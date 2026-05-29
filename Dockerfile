dockerfile
    FROM python:3.11-slim
    
    LABEL maintainer="Hermes Agent" \
          description="Production-ready Hermes Gateway for 24/7 Telegram (Modal/Railway)" \
          version="2.1"
    
    1. 系统依赖
    RUN apt-get update && apt-get install -y --no-install-recommends \
        curl git xz-utils ca-certificates \
        && rm -rf /var/lib/apt/lists/* \
        && apt-get clean
    
    2. 安装 Hermes
    RUN curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
    
    3. 关键环境变量
    ENV HERMES_HOME=/root/.hermes \
        HERMES_YOLO_MODE=1 \
        PYTHONUNBUFFERED=1 \
        MODEL_DEFAULT=grok-4.20-0309-reasoning \
        MODEL_PROVIDER=xai \
        GATEWAY_TIMEOUT=1800 \
        HERMES_GATEWAY_STRICT=false
    
    WORKDIR /root
    
    RUN mkdir -p /root/.hermes/logs /root/.hermes/sessions
    
    COPY config.yaml /root/.hermes/config.yaml 2>/dev/null || echo "Using default config"
