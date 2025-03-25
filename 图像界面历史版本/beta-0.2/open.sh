.  /./home/mod/co.sh
while :
do
clear
echo -e "$hx"
figlet Comfy UI
case $open in
1)
echo -e "$opena"
;;
2)
echo -e "$openb"
;;
3)
echo -e "$openc"
;;
0)
echo -e "$opend"
;;
esac
read -s -n1 cs
    if [ "$cs" == $'\x1b' ]; then
        read -s -n2 cs2
        if [ "$cs2" == $'[A' ]; then
            open=$((open - 1))
        elif [ "$cs2" == $'[B' ]; then
            open=$((open + 1))
        elif [ "$cs2" == $'[C' ]; then
    case $open in
    1)
        echo "  启动中. . . ."
        cd /root/ComfyUI/
        python3 main.py --cpu --disable-xformers --cpu-vae --disable-cuda-malloc --force-fp16 --fp8_e4m3fn-unet --disable-xformers --fp8_e4m3fn-text-enc --fast --disable-smart-memory --use-pytorch-cross-attention
        ;;
    2)
        echo "  启动中. . . ."
        cd /root/ComfyUI/
        python3 main.py --cpu --disable-xformers --cpu-vae --disable-cuda-malloc --force-fp16 --fp8_e4m3fn-unet --disable-xformers --fp8_e4m3fn-text-enc --fast --disable-smart-memory --use-pytorch-cross-attention
        ;;
    3)
        echo "  启动中. . . ."
        cd /root/ComfyUI/
        main.py --cpu
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
    
    if [ $open -gt 3 ]; then
    open=0
elif [ $open -lt 0 ]; then
    open=3
fi
done
