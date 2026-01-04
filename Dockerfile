# FROM python:3.11-slim
FROM nvidia/cuda:12.2.2-cudnn8-runtime-ubuntu22.04

# ENV DEBIAN_FRONTEND=noninteractive \
#     PYTHONUNBUFFERED=1 \
#     PIP_PREFER_BINARY=1 \
#     PATH="/home/sduser/.local/bin:$PATH"

# ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    python3.10 python3.10-venv pip \
    wget git \
    libgl1 libglib2.0-0

RUN pip install torch==2.1.0 torchvision==0.16.0 --index-url https://download.pytorch.org/whl/cu121

# 3. 複製啟動腳本進去
COPY entrypoint.sh /home/sduser/entrypoint.sh
RUN chmod +x /home/sduser/entrypoint.sh && \
    chown sduser:sduser /home/sduser/entrypoint.sh

# 4. 切換使用者
USER sduser
WORKDIR /home/sduser

EXPOSE 7860

# 設定入口點
ENTRYPOINT ["/home/sduser/entrypoint.sh"]
