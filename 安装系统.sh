#!/bin/bash
# 获取终端的行数和列数
rows=$(tput lines)
cols=$(tput cols)

# 计算2/3的长宽
height=$(( rows * 2 / 3 ))
width=$(( cols * 2 / 3 ))

# 显示yes/no对话框
whiptail --title "确认" --yesno "您确定要安装comfyui吗？（这将会覆盖之前的安装,不要中途退出）" $height $width

# 检查用户的选择
case $? in
    0) 
    cd /home/sd/cohui/
    git clone https://github.proxy.class3.fun/https://github.com/LY504720/android-comfyui-zerotermux.git
    cp -r /home/sd/cohui/android-comfyui-zerotermux/dmx /home/sd/dmx
    cp -r /home/sd/cohui/android-comfyui-zerotermux/dcj /home/sd/cohui/dcj
    cp -r /home/sd/cohui/android-comfyui-zerotermux/home.sh /home/qd/home.sh
    cp /home/sd/cohui/android-comfyui-zerotermux/安装系统.sh /home/qd/安装系统.sh
    rm -rf /home/sd/cohui/android-comfyui-zerotermux
rm -rf /root/comfyui
cd /root/
python3 -m venv comfyui
source comfyui/bin/activate
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
cd ComfyUI
pip3 install -r requirements.txt


source comfyui/bin/activate


echo "安装完成请重启"
cp /home/qd/home.sh /home/home.sh
;;
1)
echo "重启以重新进入此界面"
;;
esac
