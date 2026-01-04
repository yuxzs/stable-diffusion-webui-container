# FROM python:3.11-slim
FROM nvidia/cuda:13.1.0-devel-ubuntu24.04

# ENV DEBIAN_FRONTEND=noninteractive \
#     PYTHONUNBUFFERED=1 \
#     PIP_PREFER_BINARY=1 \
#     PATH="/home/sduser/.local/bin:$PATH"

ENV DEBIAN_FRONTEND=noninteractive

# # 1. 安裝系統依賴 (WebUI 執行需要的工具)
# # 加入 bc, git, libgl1 (OpenCV用), libgoogle-perftools4 (TCMalloc優化記憶體)
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     git \
#     wget \
#     curl \
#     libgl1 \
#     libglib2.0-0 \
#     libgoogle-perftools4 \
#     build-essential \
#     bc \
#     procps \
#     net-tools \
#     && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    software-properties-common \
    git \
    wget \
    libgl1 \
    libglib2.0-0 \
    google-perftools \
    bc \
    && add-apt-repository ppa:deadsnakes/ppa -y \
    && apt-get update \
    && apt-get install -y python3.10 python3.10-venv python3.10-dev python3-pip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 4. 修正 Python 連結 (讓 python3 指向 python3.10)
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1

# 5. 建立與您目前設定一致的使用者 sduser (UID 1000)
RUN useradd -m -u 1000 -s /bin/bash sduser

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
