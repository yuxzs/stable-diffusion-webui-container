#!/bin/bash
set -e

# 定義安裝目錄
INSTALL_DIR="/home/sduser/stable-diffusion-webui"

echo "Checking if Stable Diffusion WebUI exists..."

if [ ! -d "$INSTALL_DIR/webui.sh" ]; then
    echo "WebUI not found. Cloning from git..."
    git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git "$INSTALL_DIR"
else
    echo "WebUI found. Skipping clone."
    # 選擇性：每次啟動時自動更新 (如果不需要可註解掉)
    # cd "$INSTALL_DIR" && git pull
fi

cd "$INSTALL_DIR"

# 確保 venv 存在並啟動 (webui.sh 會自動處理，但我們可以在這裡微調)
echo "Launching WebUI..."

# 啟動參數說明：
# --listen: 允許外部連線
# --api: 開啟 API
# --xformers: 加速推論 (建議加上，雖然 webui.sh 會試著裝)
# --data-dir: 指定資料儲存位置 (可選)
exec ./webui.sh --listen --api --port 7860