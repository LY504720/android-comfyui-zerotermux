#!/bin/bash

cd
source comfyui/bin/activate

# 显示主菜单的函数
function show_menu {
    # 获取终端的宽度和高度
    cols=$(tput cols)
    lines=$(tput lines)
    # 根据菜单内容预留一定的空间，这里计算新的高度和宽度，取当前终端大小的2/3
    new_menu_height=$(($lines * 2 / 3))
    new_menu_width=$(($cols * 2 / 3))
    # 调用whiptail创建菜单
    whiptail --title "ComfyUI - 绘安选项" --menu "请选择操作：" $new_menu_height $new_menu_width 4 \
        "1" "启动" \
        "2" "模型管理" \
        "3" "扩展管理" \
        "4" "环境" \
        "5" "更新" 3>&1 1>&2 2>&3
}

while true; do
    while true; do
        choice=$(show_menu)
        case $choice in
            "1")
                function start_menu {
                    cols=$(tput cols)
                    lines=$(tput lines)
                    new_menu_height=$(($lines * 2 / 3))
                    new_menu_width=$(($cols * 2 / 3))
                    whiptail --title "启动选项" --menu "请选择操作：" $new_menu_height $new_menu_width 3 \
                        "1" "更快的速度" \
                        "2" "更好的质量" \
                        "3" "仅CPU" 3>&1 1>&2 2>&3
                }
                while true; do
clear
                    choice=$(start_menu)
                    case $choice in
                        "1")
                            echo "  启动中...."
                            cd /root/ComfyUI/
                            python3 main.py --cpu --disable-xformers --cpu-vae --disable-cuda-malloc --force-fp16 --fp8_e4m3fn-unet --disable-xformers --fp8_e4m3fn-text-enc --fast --disable-smart-memory --use-pytorch-cross-attention
                            ;;
                        "2")
                            echo "  启动中...."
                            cd /root/ComfyUI/
                            python3 main.py --cpu --disable-xformers --cpu-vae --disable-cuda-malloc --force-fp16 --fp8_e4m3fn-unet --disable-xformers --fp8_e4m3fn-text-enc --fast --disable-smart-memory --use-pytorch-cross-attention
                            ;;
                        "3")
                            echo "  启动中...."
                            cd /root/ComfyUI/
                            main.py --cpu
                            ;;
                        *)
                            break
                            ;;
                    esac
                done
                ;;
            "2")
                

function model_management_menu {
    # 获取终端的宽度和高度
    cols=$(tput cols)
    lines=$(tput lines)
    # 根据菜单内容预留一定的空间，这里设置为终端的2/3
    menu_height=$(($lines * 2 / 3))
    menu_width=$(($cols * 2 / 3))
    # 调用whiptail创建菜单
    whiptail --title "模型管理选项" --menu "请选择操作：" $menu_height $menu_width 3 \
        "1" "查看模型" \
        "2" "下载模型" \
        "3" "删除模型" 3>&1 1>&2 2>&3
}

while true; do
    choice=$(model_management_menu)
    case $choice in
        "1")
            
cd /root/models
clear
# 遍历当前目录下的所有项目
for dir in */; do
    # 输出文件夹，设置金色（这里用黄色近似），顶格输出
    echo -e "\033[1;33m$dir\033[0m"
    cd "$dir"
    # 遍历文件夹下的文件
    for file in *; do
        # 输出文件，前面空5格，不同类型文件会有不同颜色（依赖终端和ls的--color）
        echo -e "     \033[0m$file"
    done
    cd ..
done
echo "按任意键继续..."
read -n 1 -s key
            ;;
        "2")
        
        
        
        cd /home/sd/dmx/
            # 定义颜色和样式
GOLD='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RESET='\033[0m'
INITIAL_DIR=$(realpath -s ".")
CURRENT_DIR="$INITIAL_DIR"
FULL_PATH="$CURRENT_DIR"

# 存储目录结构
declare -a items
declare -a item_types  # 0=文件 1=目录 2=返回上级 3=不可选提示
selection=0

# 动态计算对话框尺寸
get_dialog_size() {
    term_height=$(tput lines)
    term_width=$(tput cols)
    dialog_height=$((term_height * 2 / 3))
    dialog_width=$((term_width * 2 / 3))
    [ $dialog_height -lt 10 ] && dialog_height=10
    [ $dialog_width -lt 30 ] && dialog_width=30
}

# 获取当前目录内容
update_items() {
    items=()
    item_types=()
    FULL_PATH="$CURRENT_DIR"
    
    # 仅在非初始目录显示返回上级
    if [ "$CURRENT_DIR" != "$INITIAL_DIR" ] && [ "$CURRENT_DIR" != "/" ]; then
        items+=("..")
        item_types+=(2)
    fi

    # 收集子文件夹
    while IFS= read -r -d $'\0' dir; do
        dir_name=$(basename "$dir")
        if [[ -n "$dir_name" && -d "$dir" ]]; then
            items+=("$dir_name")
            item_types+=(1)
        fi
    done < <(find "$CURRENT_DIR" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null)

    # 收集文件
    while IFS= read -r -d $'\0' file; do
        file_name=$(basename "$file")
        if [[ -n "$file_name" && -f "$file" ]]; then
            items+=("$file_name")
            item_types+=(0)
        fi
    done < <(find "$CURRENT_DIR" -mindepth 1 -maxdepth 1 -type f -print0 2>/dev/null)

    # 按修改时间排序
    mapfile -t sorted_indices < <(
        for i in "${!items[@]}"; do
            path="$CURRENT_DIR/${items[i]}"
            printf "%s\t%i\n" "$(stat -c %Y "$path" 2>/dev/null || echo 0)" "$i"
        done | sort -k1,1nr -k2,2n | cut -f2
    )

    # 重建排序数组
    declare -a temp_items=("${items[@]}")
    declare -a temp_types=("${item_types[@]}")
    items=()
    item_types=()
    for i in "${sorted_indices[@]}"; do
        items+=("${temp_items[i]}")
        item_types+=("${temp_types[i]}")
    done

    # 空目录处理
    if [ ${#items[@]} -eq 0 ]; then
        items+=("(空目录)")
        item_types+=(3)
    fi
}

# 显示界面
display_ui() {
    clear
    echo -e "${CYAN}当前路径: $FULL_PATH${RESET}\n"
    
    for i in "${!items[@]}"; do
        # 处理不可选条目
        if [ ${item_types[i]} -eq 3 ]; then
            echo -e "  ${GRAY}(空目录)${RESET}"
            continue
        fi

        # 动态生成前缀
        prefix=""
        case ${item_types[i]} in
            0) color=$BLUE; prefix="[文件] " ;;
            1) color=$GOLD; prefix="[目录] " ;;
            2) color=$CYAN; prefix="<返回> " ;;
        esac

        # 高亮选中项
        if [ $i -eq $selection ]; then
            echo -e "> ${color}${prefix}${items[i]}${RESET}"
        else
            echo -e "  ${color}${prefix}${items[i]}${RESET}"
        fi
    done
    
    echo -e "\n${GOLD}操作提示：↑↓导航 | ${CYAN}C进入目录${GOLD} | ${GREEN}X执行文件${GOLD} | Q退出${RESET}"
}

# 执行文件函数（不检测权限，直接用bash运行）
run_file() {
    file_path="$CURRENT_DIR/${items[selection]}"
    
    # 执行前确认
    if whiptail --title "确认执行" --yesno "即将用bash执行：\n\n$file_path" $dialog_height $dialog_width; then
        clear
        echo -e "${GREEN}══════════ 执行输出 ══════════${RESET}"
        
        # 使用bash执行文件
        if ! source "$file_path"; then
            echo -e "\n${RED}════════ 执行失败，返回码：$? ════════${RESET}"
        else
            echo -e "\n${GREEN}══════════ 执行成功 ══════════${RESET}"
            
            
           

# 获取终端的宽度和高度
cols=$(tput cols)
lines=$(tput lines)

# 计算新的高度和宽度
new_height=$((lines * 2 / 3))
new_width=$((cols * 2 / 3))

# Whiptail 询问界面
choice=$(whiptail --title "下载模型" \
                 --yes-button "下载" \
                 --no-button "不下载" \
                 --yesno "是否下载 \`${name}
${name1}
${name2}
${name3}
${name4}
${name5}\` ?" \
                 $new_height $new_width 3>&1 1>&2 2>&3)

# 使用 case 语句处理返回值
case $? in
    0)  # 用户点击 "下载"
        
       
# 使用 case 语句判断 model 的值
case $model in
    0)
        cd /root/ComfyUI/${cd}
        echo "开始下载模型: ${name}
        model=$model
        https=$https"
        wget -O ${name} ${https}
        ;;
    1)
    echo "正在安装主文件包"
       cd /root/ComfyUI/${cd}
        echo "开始下载模型: ${name}
        model=$model
        https=$https"
        wget -O ${name} ${https}
        
        case $models in
        1|2|3|4|5)
        echo "正在下载第一个附加包"
        cd /root/ComfyUI/${cd1}
        echo "开始下载模型: ${name1}
        model=$model
        https=$https1"
        wget -O ${name1} ${https1}
        ;;
        2|3|4|5)
        echo "正在下载第二个附加包"
        cd /root/ComfyUI/${cd2}
        echo "开始下载模型: ${name2}
        model=$model
        https=$https2"
        wget -O ${name2} ${https2}
        ;;
        3|4|5)
        echo "正在下载第三个附加包"
        cd /root/ComfyUI/${cd3}
        echo "开始下载模型: ${name3}
        model=$model
        https=$https3"
        wget -O ${name3} ${https3}
        ;;
        4|5)
        echo "正在下载第四个附加包"
        cd /root/ComfyUI/${cd4}
        echo "开始下载模型: ${name4}
        model=$model
        https=$https4"
        wget -O ${name4} ${https4}
        ;;
        5)
        echo "正在下载第五个附加包"
        cd /root/ComfyUI/${cd5}
        echo "开始下载模型: ${name5}
        model=$model
        https=$https5"
        wget -O ${name5} ${https5}
        ;;
        *)
        echo "参数错误"
        ;;
        esac
    ;;
    *)
        echo "模式错误"
        # 在这里执行当 model 不是 0 或 1 时的操作
        ;;
esac
        
        
        
        
        
        
        
        
        
        ;;
    1)  # 用户点击 "不下载"
        echo "已取消下载"
        ;;
    255)  # 用户按下 Esc 键
        echo "用户按下 Esc 键，操作被取消"
        ;;
esac
            
            
            
            
            
            
            
        fi
        
        echo -e "\n${CYAN}════════════════════════════════${RESET}"
        read -p "按Enter键返回..." -n 1
    fi
}

# 主程序
update_items
while true; do
    display_ui
    get_dialog_size

    IFS= read -s -r -n 1 key
    case "$key" in
        $'\x1b')  # 方向键处理
            read -s -r -n 2 seq
            case "$seq" in
                '[A') # 上箭头
                    ((selection > 0)) && ((selection--))
                    while [ ${item_types[selection]} -eq 3 ] && [ $selection -gt 0 ]; do
                        ((selection--))
                    done
                    ;;
                '[B') # 下箭头
                    ((selection < ${#items[@]}-1)) && ((selection++))
                    while [ ${item_types[selection]} -eq 3 ] && [ $selection -lt $((${#items[@]}-1)) ]; do
                        ((selection++))
                    done
                    ;;
            esac
            ((selection < 0)) && selection=0
            ((selection >= ${#items[@]})) && selection=$((${#items[@]}-1))
            ;;

        'C'|'c')  # 进入目录
            if [ ${#items[@]} -gt 0 ]; then
                case ${item_types[selection]} in
                    1)  # 有效目录
                        new_dir="$CURRENT_DIR/${items[selection]}"
                        if [[ -d "$new_dir" ]]; then
                            CURRENT_DIR="$new_dir"
                            selection=0
                            update_items
                        fi
                        ;;
                    2)  # 返回上级
                        new_dir=$(dirname "$CURRENT_DIR")
                        new_dir=$(realpath -s "$new_dir")
                if [ "$new_dir" != "$(dirname "$INITIAL_DIR")" ] || [ "$INITIAL_DIR" == "/" ]; then
                            [ "$new_dir" == "." ] && new_dir="/"
                            CURRENT_DIR="$new_dir"
                            selection=0
                            update_items
                        fi
                        ;;
                esac
            fi
            ;;

        'X'|'x')  # 执行文件
            if [ ${#items[@]} -gt 0 ] && [ ${item_types[selection]} -eq 0 ]; then
                run_file
            else
                whiptail --title "禁止操作" --msgbox "只能执行文件！" $((dialog_height/2)) $dialog_width
            fi
            ;;

        'Q'|'q')
            break
            ;;
    esac
done
            
            

            
            
            
            
            ;;
        "3")
        
        
        
        cd /root/ComfyUI/models/
# 定义颜色和样式
GOLD='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
RESET='\033[0m'
INITIAL_DIR=$(realpath -s ".")
CURRENT_DIR="$INITIAL_DIR"
FULL_PATH="$CURRENT_DIR"

# 存储目录结构
declare -a items
declare -a item_types  # 0=文件 1=目录 2=返回上级
selection=0

# 动态计算对话框尺寸
get_dialog_size() {
    term_height=$(tput lines)
    term_width=$(tput cols)
    dialog_height=$((term_height * 2 / 3))
    dialog_width=$((term_width * 2 / 3))
    [ $dialog_height -lt 10 ] && dialog_height=10
    [ $dialog_width -lt 30 ] && dialog_width=30
}

# 安全获取目录内容
update_items() {
    items=()
    item_types=()
    FULL_PATH="$CURRENT_DIR"
    
    # 显示返回上级选项（仅在非初始目录）
    if [ "$CURRENT_DIR" != "$INITIAL_DIR" ] && [ "$CURRENT_DIR" != "/" ]; then
        items+=("..")
        item_types+=(2)
    fi

    # 收集有效子目录
    while IFS= read -r -d $'\0' dir; do
        dir_name=$(basename "$dir")
        if [[ -n "$dir_name" && -d "$dir" ]]; then
            items+=("$dir_name")
            item_types+=(1)
        fi
    done < <(find "$CURRENT_DIR" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null)

    # 收集有效文件
    while IFS= read -r -d $'\0' file; do
        file_name=$(basename "$file")
        if [[ -n "$file_name" && -f "$file" ]]; then
            items+=("$file_name")
            item_types+=(0)
        fi
    done < <(find "$CURRENT_DIR" -mindepth 1 -maxdepth 1 -type f -print0 2>/dev/null)

    # 按修改时间排序
    mapfile -t sorted_indices < <(
        for i in "${!items[@]}"; do
            path="$CURRENT_DIR/${items[i]}"
            printf "%s\t%i\n" "$(stat -c %Y "$path" 2>/dev/null || echo 0)" "$i"
        done | sort -k1,1nr -k2,2n | cut -f2
    )

    # 重建排序数组
    declare -a temp_items=("${items[@]}")
    declare -a temp_types=("${item_types[@]}")
    items=()
    item_types=()
    for i in "${sorted_indices[@]}"; do
        items+=("${temp_items[i]}")
        item_types+=("${temp_types[i]}")
    done

    # 空目录处理
    if [ ${#items[@]} -eq 0 ]; then
        items+=("(空目录)")
        item_types+=(3)
    fi
}

# 显示界面
display_ui() {
    clear
    echo -e "${CYAN}当前路径: $FULL_PATH${RESET}\n"
    
    for i in "${!items[@]}"; do
        # 处理不可选条目
        if [ ${item_types[i]} -eq 3 ]; then
            echo -e "  ${GRAY}(空目录)${RESET}"
            continue
        fi
        # 动态生成前缀
        prefix=""
        case ${item_types[i]} in
            0) color=$BLUE; prefix="[文件] " ;;
            1) color=$GOLD; prefix="[目录] " ;;
            2) color=$CYAN; prefix="<返回> " ;;
        esac

        # 高亮选中项
        if [ $i -eq $selection ]; then
            echo -e "> ${color}${prefix}${items[i]}${RESET}"
        else
            echo -e "  ${color}${prefix}${items[i]}${RESET}"
        fi
    done
    
    echo -e "\n${GOLD}操作提示：↑↓导航 | ${CYAN}C进入目录${GOLD} | ${RED}R删除文件${GOLD} | Q退出${RESET}"
}

# 主程序
update_items
while true; do
    display_ui
    get_dialog_size

    IFS= read -s -r -n 1 key
    case "$key" in
        $'\x1b')  # 方向键处理
            read -s -r -n 2 seq
            case "$seq" in
                '[A') # 上箭头
                    ((selection > 0)) && ((selection--))
                    # 跳过不可选条目
                    while [ ${item_types[selection]} -eq 3 ] && [ $selection -gt 0 ]; do
                        ((selection--))
                    done
                    ;;
                '[B') # 下箭头
                    ((selection < ${#items[@]}-1)) && ((selection++))
                    # 跳过不可选条目
                    while [ ${item_types[selection]} -eq 3 ] && [ $selection -lt $((${#items[@]}-1)) ]; do
                        ((selection++))
                    done
                    ;;
            esac
            # 边界保护
            ((selection < 0)) && selection=0
            ((selection >= ${#items[@]})) && selection=$((${#items[@]}-1))
            ;;

'C'|'c')  # 进入目录或返回上级
    if [ ${#items[@]} -gt 0 ]; then
        case ${item_types[selection]} in
            1)  # 进入子目录
                new_dir="$CURRENT_DIR/${items[selection]}"
                if [[ -d "$new_dir" ]]; then
                    CURRENT_DIR="$new_dir"
                    selection=0
                    update_items
                fi
                ;;
            2)  # 返回上级
                # 修正的路径处理逻辑
                new_dir=$(dirname "$CURRENT_DIR")
                new_dir=$(realpath -s "$new_dir")
                
                # 允许返回到初始目录，但禁止其上级目录
                if [[ "$new_dir" != "$(dirname "$INITIAL_DIR")" || "$INITIAL_DIR" == "/" ]]; then
                    # 处理根目录特殊情况
                    if [ "$new_dir" == "." ]; then
                        new_dir="/"
                    fi
                    
                    # 更新当前目录
                    CURRENT_DIR="$new_dir"
                    selection=0
                    update_items
                else
                    whiptail --title "禁止访问" --msgbox "已到达初始目录的上级限制！" $((dialog_height/2)) $dialog_width
                fi
                ;;
        esac
    fi
    ;;

        'R'|'r')  #删除文件
            if [ ${#items[@]} -gt 0 ] && [ ${item_types[selection]} -eq 0 ]; then
                target_name="${items[selection]}"
                target_path="$CURRENT_DIR/$target_name"

                if whiptail --title "确认删除" --yesno "即将永久删除文件：\n\n$target_path" $dialog_height $dialog_width; then
                    if rm -f "$target_path"; then
                        update_items
                        # 自动调整选中位置
                        selection=$((selection > ${#items[@]}-1 ? ${#items[@]}-1 : selection))
                        while [ ${item_types[selection]} -eq 3 ] && [ $selection -gt 0 ]; do
                            ((selection--))
                        done
                    else
                        whiptail --title "错误" --msgbox "删除失败！\n权限不足或文件不存在" $((dialog_height/2)) $dialog_width
                    fi
                fi
            else
                whiptail --title "禁止操作" --msgbox "只能删除文件！" $((dialog_height/2)) $dialog_width
            fi
            ;;

        'Q'|'q')
            break
            ;;
    esac
done 
            
            
            
            ;;
        *)
            break
            ;;
    esac
done
                ;;
            "3")
                
# 获取终端当前长宽
TERM_WIDTH=$(tput cols)
TERM_HEIGHT=$(tput lines)

# 计算2/3大小
MENU_WIDTH=$((TERM_WIDTH * 2 / 3))
MENU_HEIGHT=$((TERM_HEIGHT * 2 / 3))

# 显示菜单并捕获选择结果
CHOICE=$(whiptail --title "扩展管理" \
                  --menu "请选择操作：" \
                  $MENU_HEIGHT $MENU_WIDTH 3 \
                  "1" "查看插件" \
                  "2" "安装插件" \
                  "3" "删除插件" \
                  3>&1 1>&2 2>&3)

# 根据选择执行操作
case $CHOICE in
    "1")
        cd /root/ComfyUI/custom_nodes
clear
# 遍历当前目录下的所有项目
for dir in */; do
    # 输出文件夹，设置金色（这里用黄色近似），顶格输出
    echo -e "\033[1;33m$dir\033[0m"
    cd "$dir"
    # 遍历文件夹下的文件
    for file in *; do
        # 输出文件，前面空5格，不同类型文件会有不同颜色（依赖终端和ls的--color）
        echo -e "     \033[0m$file"
    done
    cd ..
done
echo "按任意键继续..."
read -n 1 -s key
            
        ;;
    "2")
        
        
       
        cd /home/sd//cohui/dcj
            # 定义颜色和样式
GOLD='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RESET='\033[0m'
INITIAL_DIR=$(realpath -s ".")
CURRENT_DIR="$INITIAL_DIR"
FULL_PATH="$CURRENT_DIR"

# 存储目录结构
declare -a items
declare -a item_types  # 0=文件 1=目录 2=返回上级 3=不可选提示
selection=0

# 动态计算对话框尺寸
get_dialog_size() {
    term_height=$(tput lines)
    term_width=$(tput cols)
    dialog_height=$((term_height * 2 / 3))
    dialog_width=$((term_width * 2 / 3))
    [ $dialog_height -lt 10 ] && dialog_height=10
    [ $dialog_width -lt 30 ] && dialog_width=30
}

# 获取当前目录内容
update_items() {
    items=()
    item_types=()
    FULL_PATH="$CURRENT_DIR"
    
    # 仅在非初始目录显示返回上级
    if [ "$CURRENT_DIR" != "$INITIAL_DIR" ] && [ "$CURRENT_DIR" != "/" ]; then
        items+=("..")
        item_types+=(2)
    fi

    # 收集子文件夹
    while IFS= read -r -d $'\0' dir; do
        dir_name=$(basename "$dir")
        if [[ -n "$dir_name" && -d "$dir" ]]; then
            items+=("$dir_name")
            item_types+=(1)
        fi
    done < <(find "$CURRENT_DIR" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null)

    # 收集文件
    while IFS= read -r -d $'\0' file; do
        file_name=$(basename "$file")
        if [[ -n "$file_name" && -f "$file" ]]; then
            items+=("$file_name")
            item_types+=(0)
        fi
    done < <(find "$CURRENT_DIR" -mindepth 1 -maxdepth 1 -type f -print0 2>/dev/null)

    # 按修改时间排序
    mapfile -t sorted_indices < <(
        for i in "${!items[@]}"; do
            path="$CURRENT_DIR/${items[i]}"
            printf "%s\t%i\n" "$(stat -c %Y "$path" 2>/dev/null || echo 0)" "$i"
        done | sort -k1,1nr -k2,2n | cut -f2
    )

    # 重建排序数组
    declare -a temp_items=("${items[@]}")
    declare -a temp_types=("${item_types[@]}")
    items=()
    item_types=()
    for i in "${sorted_indices[@]}"; do
        items+=("${temp_items[i]}")
        item_types+=("${temp_types[i]}")
    done

    # 空目录处理
    if [ ${#items[@]} -eq 0 ]; then
        items+=("(空目录)")
        item_types+=(3)
    fi
}

# 显示界面
display_ui() {
    clear
    echo -e "${CYAN}当前路径: $FULL_PATH${RESET}\n"
    
    for i in "${!items[@]}"; do
        # 处理不可选条目
        if [ ${item_types[i]} -eq 3 ]; then
            echo -e "  ${GRAY}(空目录)${RESET}"
            continue
        fi

        # 动态生成前缀
        prefix=""
        case ${item_types[i]} in
            0) color=$BLUE; prefix="[文件] " ;;
            1) color=$GOLD; prefix="[目录] " ;;
            2) color=$CYAN; prefix="<返回> " ;;
        esac

        # 高亮选中项
        if [ $i -eq $selection ]; then
            echo -e "> ${color}${prefix}${items[i]}${RESET}"
        else
            echo -e "  ${color}${prefix}${items[i]}${RESET}"
        fi
    done
    
    echo -e "\n${GOLD}操作提示：↑↓导航 | ${CYAN}C进入目录${GOLD} | ${GREEN}X执行文件${GOLD} | Q退出${RESET}"
}

# 执行文件函数（不检测权限，直接用bash运行）
run_file() {
    file_path="$CURRENT_DIR/${items[selection]}"
    
    # 执行前确认
    if whiptail --title "确认执行" --yesno "即将用bash执行：\n\n$file_path" $dialog_height $dialog_width; then
        clear
        echo -e "${GREEN}══════════ 执行输出 ══════════${RESET}"
        
        # 使用bash执行文件
        if ! source "$file_path"; then
            echo -e "\n${RED}════════ 执行失败，返回码：$? ════════${RESET}"
        else
            echo -e "\n${GREEN}══════════ 执行成功 ══════════${RESET}"
            
            
           

# 获取终端的宽度和高度
cols=$(tput cols)
lines=$(tput lines)

# 计算新的高度和宽度
new_height=$((lines * 2 / 3))
new_width=$((cols * 2 / 3))

# Whiptail 询问界面
choice=$(whiptail --title "下载模型" \
                 --yes-button "下载" \
                 --no-button "不下载" \
                 --yesno "是否下载 \`${name}
${name1}
${name2}
${name3}
${name4}
${name5}\` ?" \
                 $new_height $new_width 3>&1 1>&2 2>&3)

# 使用 case 语句处理返回值
case $? in
    0)  # 用户点击 "下载"
       cd /root/ComfyUI/custom_nodes
       #插件安装逻辑
       echo "正在安装${name}"
       git clone  ${https}
       cd ${name}
       if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
else
    echo "
    
    没有 requirements.txt 文件，跳过依赖安装"
fi

        
        
        
        
        
        
        
        
        
        ;;
    1)  # 用户点击 "不下载"
        echo "已取消下载"
        ;;
    255)  # 用户按下 Esc 键
        echo "用户按下 Esc 键，操作被取消"
        ;;
esac
            
            
            
            
            
            
            
        fi
        
        echo -e "\n${CYAN}════════════════════════════════${RESET}"
        read -p "按Enter键返回..." -n 1
    fi
}

# 主程序
update_items
while true; do
    display_ui
    get_dialog_size

    IFS= read -s -r -n 1 key
    case "$key" in
        $'\x1b')  # 方向键处理
            read -s -r -n 2 seq
            case "$seq" in
                '[A') # 上箭头
                    ((selection > 0)) && ((selection--))
                    while [ ${item_types[selection]} -eq 3 ] && [ $selection -gt 0 ]; do
                        ((selection--))
                    done
                    ;;
                '[B') # 下箭头
                    ((selection < ${#items[@]}-1)) && ((selection++))
                    while [ ${item_types[selection]} -eq 3 ] && [ $selection -lt $((${#items[@]}-1)) ]; do
                        ((selection++))
                    done
                    ;;
            esac
            ((selection < 0)) && selection=0
            ((selection >= ${#items[@]})) && selection=$((${#items[@]}-1))
            ;;

        'C'|'c')  # 进入目录
            if [ ${#items[@]} -gt 0 ]; then
                case ${item_types[selection]} in
                    1)  # 有效目录
                        new_dir="$CURRENT_DIR/${items[selection]}"
                        if [[ -d "$new_dir" ]]; then
                            CURRENT_DIR="$new_dir"
                            selection=0
                            update_items
                        fi
                        ;;
                    2)  # 返回上级
                        new_dir=$(dirname "$CURRENT_DIR")
                        new_dir=$(realpath -s "$new_dir")
                if [ "$new_dir" != "$(dirname "$INITIAL_DIR")" ] || [ "$INITIAL_DIR" == "/" ]; then
                            [ "$new_dir" == "." ] && new_dir="/"
                            CURRENT_DIR="$new_dir"
                            selection=0
                            update_items
                        fi
                        ;;
                esac
            fi
            ;;

        'X'|'x')  # 执行文件
            if [ ${#items[@]} -gt 0 ] && [ ${item_types[selection]} -eq 0 ]; then
                run_file
            else
                whiptail --title "禁止操作" --msgbox "只能执行文件！" $((dialog_height/2)) $dialog_width
            fi
            ;;

        'Q'|'q')
            break
            ;;
    esac
done
        
        
        ;;
        
        
        
    "3")
        
        
        cd /root/ComfyUI/custom_nodes
# 定义颜色和样式
GOLD='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
RESET='\033[0m'
INITIAL_DIR=$(realpath -s ".")
CURRENT_DIR="$INITIAL_DIR"
FULL_PATH="$CURRENT_DIR"

# 存储目录结构
declare -a items
declare -a item_types  # 0=文件 1=目录 2=返回上级 3=空目录
selection=0

# 动态计算对话框尺寸
get_dialog_size() {
    term_height=$(tput lines)
    term_width=$(tput cols)
    dialog_height=$((term_height * 2 / 3))
    dialog_width=$((term_width * 2 / 3))
    [ $dialog_height -lt 10 ] && dialog_height=10
    [ $dialog_width -lt 30 ] && dialog_width=30
}

# 安全获取目录内容（新增过滤__pycache__）
update_items() {
    items=()
    item_types=()
    FULL_PATH="$CURRENT_DIR"
    
    # 显示返回上级选项（仅在非初始目录）
    if [ "$CURRENT_DIR" != "$INITIAL_DIR" ] && [ "$CURRENT_DIR" != "/" ]; then
        items+=("..")
        item_types+=(2)
    fi

    # 收集有效子目录（排除__pycache__）
    while IFS= read -r -d $'\0' dir; do
        dir_name=$(basename "$dir")
        if [[ -n "$dir_name" && -d "$dir" ]]; then
            items+=("$dir_name")
            item_types+=(1)
        fi
    done < <(find "$CURRENT_DIR" -mindepth 1 -maxdepth 1 -type d ! -name "__pycache__" -print0 2>/dev/null)

    # 收集有效文件（可选保留）
    # while IFS= read -r -d $'\0' file; do
    #     file_name=$(basename "$file")
    #     if [[ -n "$file_name" && -f "$file" ]]; then
    #         items+=("$file_name")
    #         item_types+=(0)
    #     fi
    # done < <(find "$CURRENT_DIR" -mindepth 1 -maxdepth 1 -type f -print0 2>/dev/null)

    # 按修改时间排序
    mapfile -t sorted_indices < <(
        for i in "${!items[@]}"; do
            path="$CURRENT_DIR/${items[i]}"
            printf "%s\t%i\n" "$(stat -c %Y "$path" 2>/dev/null || echo 0)" "$i"
        done | sort -k1,1nr -k2,2n | cut -f2
    )

    # 重建排序数组
    declare -a temp_items=("${items[@]}")
    declare -a temp_types=("${item_types[@]}")
    items=()
    item_types=()
    for i in "${sorted_indices[@]}"; do
        items+=("${temp_items[i]}")
        item_types+=("${temp_types[i]}")
    done

    # 空目录处理
    if [ ${#items[@]} -eq 0 ]; then
        items+=("(空目录)")
        item_types+=(3)
    fi
}

# 显示界面（修改操作提示）
display_ui() {
    clear
    echo -e "${CYAN}当前路径: $FULL_PATH${RESET}\n"
    
    for i in "${!items[@]}"; do
        # 处理不可选条目
        if [ ${item_types[i]} -eq 3 ]; then
            echo -e "  ${GRAY}(空目录)${RESET}"
            continue
        fi
        # 动态生成前缀
        prefix=""
        case ${item_types[i]} in
            0) color=$BLUE; prefix="[文件] " ;;
            1) color=$GOLD; prefix="[目录] " ;;
            2) color=$CYAN; prefix="<返回> " ;;
        esac

        # 高亮选中项
        if [ $i -eq $selection ]; then
            echo -e "> ${color}${prefix}${items[i]}${RESET}"
        else
            echo -e "  ${color}${prefix}${items[i]}${RESET}"
        fi
    done
    
    echo -e "\n${GOLD}操作提示：↑↓导航 | ${CYAN}C进入目录${GOLD} | ${RED}R删除目录${GOLD} | Q退出${RESET}"
}

# 主程序（修改删除逻辑）
update_items
while true; do
    display_ui
    get_dialog_size

    IFS= read -s -r -n 1 key
    case "$key" in
        $'\x1b')  # 方向键处理
            read -s -r -n 2 seq
            case "$seq" in
                '[A') # 上箭头
                    ((selection > 0)) && ((selection--))
                    while [ ${item_types[selection]} -eq 3 ] && [ $selection -gt 0 ]; do
                        ((selection--))
                    done
                    ;;
                '[B') # 下箭头
                    ((selection < ${#items[@]}-1)) && ((selection++))
                    while [ ${item_types[selection]} -eq 3 ] && [ $selection -lt $((${#items[@]}-1)) ]; do
                        ((selection++))
                    done
                    ;;
            esac
            ((selection < 0)) && selection=0
            ((selection >= ${#items[@]})) && selection=$((${#items[@]}-1))
            ;;

        'C'|'c')  # 进入目录或返回上级
            if [ ${#items[@]} -gt 0 ]; then
                case ${item_types[selection]} in
                    1)  # 进入子目录
                        new_dir="$CURRENT_DIR/${items[selection]}"
                        if [[ -d "$new_dir" ]]; then
                            CURRENT_DIR="$new_dir"
                            selection=0
                            update_items
                        fi
                        ;;
                    2)  # 返回上级
                        new_dir=$(dirname "$CURRENT_DIR")
                        new_dir=$(realpath -s "$new_dir")
                        if [ "$new_dir" != "$(dirname "$INITIAL_DIR")" ] || [ "$INITIAL_DIR" == "/" ]; then
                            CURRENT_DIR="$new_dir"
                            selection=0
                            update_items
                        else
                            whiptail --title "禁止访问" --msgbox "已到达初始目录的上级限制！" $((dialog_height/2)) $dialog_width
                        fi
                        ;;
                esac
            fi
            ;;

        'R'|'r')  # 删除目录（原文件删除已禁用）
          if [ ${#items[@]} -gt 0 ] && [ ${item_types[selection]} -eq 1 ]; then
                target_name="${items[selection]}"
                target_path="$CURRENT_DIR/$target_name"
                
                # 二次确认
                if whiptail --title "确认删除" --yesno "即将删除目录：\n\n$target_path\n\n包含的所有文件将被永久删除！" $dialog_height $dialog_width; then
                    # 安全删除目录
                    if rm -rf "$target_path"; then
                        update_items
                        selection=$((selection > ${#items[@]}-1 ? ${#items[@]}-1 : selection))
                        while [ ${item_types[selection]} -eq 3 ] && [ $selection -gt 0 ]; do
                            ((selection--))
                        done
                    else
                        whiptail --title "错误" --msgbox "删除失败！\n权限不足或目录不存在" $((dialog_height/2)) $dialog_width
                    fi
                fi
            else
                whiptail --title "禁止操作" --msgbox "只能删除目录！" $((dialog_height/2)) $dialog_width
            fi
            ;;

        'Q'|'q')
            break
            ;;
    esac
done
   
        
        
        
        
        
        
        
        
        
        ;;
    *)
        echo "操作已取消"
        ;;
esac
                ;;
            "4")
               
#!/bin/bash

# 获取终端尺寸并计算2/3大小
TERM_WIDTH=$(tput cols)
TERM_HEIGHT=$(tput lines)
DIALOG_WIDTH=$((TERM_WIDTH * 2 / 3))
DIALOG_HEIGHT=$((TERM_HEIGHT * 2 / 3))

# 设置最小尺寸
[ $DIALOG_WIDTH -lt 40 ] && DIALOG_WIDTH=40
[ $DIALOG_HEIGHT -lt 10 ] && DIALOG_HEIGHT=10

# 显示菜单并获取选择
choice=$(whiptail --title "环境配置" \
         --menu "请选择操作：" \
         $DIALOG_HEIGHT $DIALOG_WIDTH 6 \
         "1" "关于" \
         "2" "语言" \
         "3" "Python环境自检" \
         "4" "备份Python环境" \
         "5" "还原Python环境" \
         "6" "重置Python环境" \
         3>&1 1>&2 2>&3)

# 处理用户选择
case $choice in
    "1")
        whiptail --title "关于" --msgbox "环境配置管理工具 v1.0" 8 $DIALOG_WIDTH
        ;;
    "2")
        lang=$(whiptail --title "语言设置" --menu "选择语言" 10 $DIALOG_WIDTH 2 \
              "1" "简体中文" \
              "2" "English" 3>&1 1>&2 2>&3)
        [ "$lang" = "1" ] && echo "语言设置为中文" || echo "貌似并没有英文版"
        ;;
    "3")
        py_version=$(python3 --version 2>&1 || echo "未安装")
        whiptail --title "Python环境" --msgbox "当前Python版本:\n$py_version" 10 $DIALOG_WIDTH
        ;;
    "4")
        whiptail --title "备份" --msgbox "开始备份Python环境..." 8 $DIALOG_WIDTH
        cd /root/
        echo "这将覆盖原有备份你确认吗？ctrl+c强制退出"
        read wyy
        tar -czvf venv.tar.gz /root/comfyui
        echo "备份完成，按任意键继续......"
        read wyy
        ;;
    "5")
        whiptail --title "还原" --msgbox "正在还原Python系统..." 8 $DIALOG_WIDTH
        
        echo "这将覆盖原有环境你确认吗？ctrl+c强制退出"
        read wyy
        tar -xzvf venv.tar.gz
        echo "还原完成，按任意键继续......"
        read wyy
        
        
        
        ;;
    "6")
        if whiptail --title "警告" --yesno "确定要重置Python环境吗？" 8 $DIALOG_WIDTH; then
            whiptail --title "重置" --msgbox "开始重置环境..." 8 $DIALOG_WIDTH
            rm -rf /root/comfyui
python3 -m venv comfyui
source comfyui/bin/activate
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
cd ComfyUI
pip3 install -r requirements.txt


source comfyui/bin/activate
            
            
            
            
        fi
        ;;
    *)
        echo "用户取消选择"
        ;;
esac
                #666666
                
                
                
                
                
                ;;
            "5")
            echo "你确定要更新吗？（可能会有未知的bug）ctrl+c强制退出"
            read wyy
                cd /home/sd/cohui/
                rm -rf android-comfyui-zerotermux
                git clone https://github.proxy.class3.fun/https://github.com/LY504720/android-comfyui-zerotermux.git
                cp /home/sd/cohui/android-comfyui-zerotermux/dmx /home/sd/dmx
    cp /home/sd/cohui/android-comfyui-zerotermux/dcj /home/sd/cohui/dcj
    cp /home/sd/cohui/android-comfyui-zerotermux/home.sh /home/qd/home.sh
    cp /home/sd/cohui/android-comfyui-zerotermux/安装系统.sh /home/qd/安装系统.sh
    rm /home/sd/cohui/android-comfyui-zerotermux
                echo "更新完成，点击任意键继续....."
                read wyy
                
                
                ;;
            *)
                break
                ;;
        esac
    done
    if whiptail --yesno "你确定要退出ComfyUI - 绘安系统吗？" 8 30; then
        echo "正在退出..."
clear
        exit 0
    fi
done
clear
