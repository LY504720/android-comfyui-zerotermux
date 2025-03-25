.  /./home/mod/co.sh
cd
source comfyui_1/bin/activate
while :
do
clear
echo -e "$hx"
figlet Comfy UI
case $home in
1)
echo -e "$homea"
;;
2)
echo -e "$homeb"
;;
3)
echo -e "$homec"
;;
0)
echo -e "$homed"
;;
esac
read -s -n1 cs
    if [ "$cs" == $'\x1b' ]; then
        read -s -n2 cs2
        if [ "$cs2" == $'[A' ]; then
            home=$((home - 1))
        elif [ "$cs2" == $'[B' ]; then
            home=$((home + 1))
        elif [ "$cs2" == $'[C' ]; then
    case $home in
    1)
        bash /home/mod/open.sh
        ;;
    2)
    echo "建设中....."
    read -s -n1 c
        bash /home/mod/sz.sh
        ;;
    3)
    echo "建设中......"
    read -s -n1 c
        bash /home/mod/gjsz.sh
        ;;
    0)
    clear
       exit 0
        ;;
    *)
        ;;
        esac
        elif [ "$cs2" == $'[D' ]; then
            exit 0
        fi
    fi
    
    if [ $home -gt 3 ]; then
    home=0
elif [ $home -lt 0 ]; then
    home=3
fi
done
