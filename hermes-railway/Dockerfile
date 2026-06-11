FROM python:3.11-slim-bookworm

# 最小化构建层，加快 Railway build
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 安装 Hermes (这是瓶颈，但目前最简单方式)
RUN curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash

ENV HERMES_HOME=/root/.hermes \
    HERMES_YOLO_MODE=1 \
    PYTHONUNBUFFERED=1 \
    MODEL_PROVIDER=xai \
    MODEL_DEFAULT=grok-4.20-0309-reasoning

WORKDIR /root

# 复制 startup 脚本
COPY railway-startup.sh /root/railway-startup.sh
RUN chmod +x /root/railway-startup.sh

# 预创建目录
RUN mkdir -p /root/.hermes

CMD ["/root/railway-startup.sh"]
