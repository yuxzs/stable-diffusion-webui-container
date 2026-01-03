# 使用官方 Python 3.10 slim 版本 (Debian based) 以獲得最佳相容性
FROM python:3.10-slim

# 設定環境變數
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_PREFER_BINARY=1 \
    SD_WEBUI_CACHE_DIR=/home/sduser/.cache

# 安裝必要的系統依賴 (git, libgl1 用於 cv2, tcmon 等)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    libgl1 \
    libglib2.0-0 \
    libgoogle-perftools4 \
    wget \
    build-essential \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 建立非 root 使用者 (安全最佳實踐)
RUN useradd -m -s /bin/bash sduser

# 切換到 sduser
USER sduser
WORKDIR /home/sduser

# 下載 Stable Diffusion WebUI
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git

WORKDIR /home/sduser/stable-diffusion-webui

# 預先建立 venv 並安裝依賴 (這一步能減少容器啟動時間)
# 注意：這裡我們先跑一次並跳過 torch 檢查，目的是為了讓它下載大部分依賴
RUN python3.10 -m venv venv && \
    . venv/bin/activate && \
    pip install --upgrade pip wheel && \
    pip install -r requirements_versions.txt

# 暴露預設埠
EXPOSE 7860

# 設定啟動指令
# --listen 讓它能接受外部連線 (K3s Service 需要)
# --api 開啟 API
CMD ["./webui.sh", "--listen", "--api", "--port", "7860"]