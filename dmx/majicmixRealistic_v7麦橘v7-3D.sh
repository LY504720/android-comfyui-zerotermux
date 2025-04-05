#绘安模型安装包
#该安装包由bilibili：杨柳鲤余 制作
#安装包放在ubuntu目录下的/home/sd/dmx
#model选项为安装模式（0或1）0为单网址安装，1为多网址安装安装（最多5个附加包）
#cd选项是模型安装目录
#以root为初始目录
#name是模型的名字
#https是模型地址
model="1"


cd=models/checkpoints
name=majicmixRealistic_v7.safetensors
https="https://hf-mirror.com/digiplay/majicMIX_realistic_v7/resolve/main/majicmixRealistic_v7.safetensors"
#以上必填

#0模式下选填，1模式下必填（不填也可以，但是不建议这么做，因为会占用资源）
models="1"
#models是附加包的数量可以是1，2，3，4，5请务必按顺序填

#cd1是附加包1的安装目录
cd1=models/vae
#name1是附加包1的名字名字
name1=diffusion_pytorch_model.fp16.safetensors
#http1是附加包1的模型地址
https1="https://hf-mirror.com/digiplay/majicMIX_realistic_v7/resolve/main/vae/diffusion_pytorch_model.fp16.safetensors"

#以此类推
cd2=
name2=
https2=

cd3=
name3=
https3=

cd4=
name4=
https4=

cd5=
name5=
https5=