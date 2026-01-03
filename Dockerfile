FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_PREFER_BINARY=1 \
    PATH="/home/sduser/.local/bin:$PATH"

# 1. 安裝系統依賴 (WebUI 執行需要的工具)
# 加入 bc, git, libgl1 (OpenCV用), libgoogle-perftools4 (TCMalloc優化記憶體)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    wget \
    curl \
    libgl1 \
    libglib2.0-0 \
    libgoogle-perftools4 \
    build-essential \
    bc \
    procps \
    net-tools \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. 建立使用者
RUN useradd -m -s /bin/bash sduser

# 3. 複製啟動腳本進去
COPY entrypoint.sh /home/sduser/entrypoint.sh
RUN chmod +x /home/sduser/entrypoint.sh && \
    chown sduser:sduser /home/sduser/entrypoint.sh

# 4. 切換使用者
USER sduser
WORKDIR /home/sduser

# 這裡不建立 venv，也不下載 code，全部交給 entrypoint.sh 在執行時處理

EXPOSE 7860

# 設定入口點
ENTRYPOINT ["/home/sduser/entrypoint.sh"]