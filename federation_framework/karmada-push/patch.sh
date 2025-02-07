#!/bin/bash

set -e  # 啟用錯誤檢測，任何錯誤都會導致腳本終止

CONFIG_FILE="/etc/containerd/config.toml"
BACKUP_FILE="/etc/containerd/config.toml.bak"

# **備份原始設定檔**
echo "🔄 備份原始 $CONFIG_FILE 到 $BACKUP_FILE"
sudo cp $CONFIG_FILE $BACKUP_FILE

# **修改 containerd 配置**
echo "🛠 更新 containerd 鏡像站點配置"

# 確保 `[plugins."io.containerd.grpc.v1.cri".registry]` 存在
if ! grep -q '\[plugins."io.containerd.grpc.v1.cri".registry\]' $CONFIG_FILE; then
    echo -e "\n[plugins.\"io.containerd.grpc.v1.cri\".registry]\n" | sudo tee -a $CONFIG_FILE > /dev/null
fi

# 檢查 `docker.io` 是否已經有鏡像站點設定，如果有則更新，否則新增
if grep -q '\[plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"\]' $CONFIG_FILE; then
    sudo sed -i '/\[plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"\]/,/endpoint/d' $CONFIG_FILE
fi

# 新增或替換 `docker.io` 的 `endpoint`
sudo tee -a $CONFIG_FILE > /dev/null <<EOL
[plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
  endpoint = ["http://docker-cache.grid5000.fr"]
EOL

echo "✅ 鏡像站點已更新為 http://docker-cache.grid5000.fr"

# **重新啟動 containerd**
echo "🔄 重新啟動 containerd..."
sudo systemctl restart containerd

# **確認 containerd 是否成功運行**
if systemctl is-active --quiet containerd; then
    echo "✅ containerd 重新啟動成功！"
else
    echo "❌ containerd 啟動失敗，請檢查 $CONFIG_FILE"
    exit 1
fi