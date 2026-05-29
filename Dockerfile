FROM python:3.11-slim

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    curl git \
    && rm -rf /var/lib/apt/lists/*

# 安装 Hermes
RUN curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash

# 设置环境
ENV HERMES_HOME=/root/.hermes
ENV HERMES_YOLO_MODE=1
WORKDIR /root

# 复制本地配置（如果有）
COPY .hermes /root/.hermes

CMD ["hermes", "gateway", "run", "--replace"]
