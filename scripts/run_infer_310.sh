if [[ $# -lt 4 || $# -gt 5 ]]; then
    echo "Usage: bash run_infer_310.sh [MINDIR_PATH] [DATA_PATH] [DVPP] [CONFIG_PATH] [DEVICE_ID]
    DVPP is mandatory, and must choose from [DVPP|CPU], it's case-insensitive
    DEVICE_ID is optional, it can be set by environment variable device_id, otherwise the value is zero"
exit 1
fi

get_real_path(){
    if [ "${1:0:1}" == "/" ]; then
        echo "$1"
    else
        echo "$(realpath -m $PWD/$1)"
    fi
}
model=$(get_real_path $1)
data_path=$(get_real_path $2)
cfg_path=$4

device_id=0
if [ $# == 5 ]; then
    device_id=$5
fi

echo "mindir name: "$model
echo "dataset path: "$data_path
echo "config path: " $cfg_path
echo "device id: "$device_id

function compile_app()
{
    cd ../ascend310_infer || exit
    bash build.sh &> build.log
}

function infer()
{
    cd - || exit
    if [ -d result_Files ]; then
        rm -rf ./result_Files
    fi
    if [ -d time_Result ]; then
        rm -rf ./time_Result
    fi
    mkdir result_Files
    mkdir time_Result
    image_shape=`cat ${cfg_path} | grep img_shape`
    height=${image_shape:12:3}
    width=${image_shape:17:3}

    ../ascend310_infer/out/main --mindir_path=$model --dataset_path=$data_path --cpu_dvpp=CPU --device_id=$device_id --image_height=$height --image_width=$width &> infer.log
}

function cal_acc()
{
    python ../postprocess.py --result_path=./result_Files --img_path=$data_path --config_path=${cfg_path} --drop=True &> acc.log &
}

compile_app
if [ $? -ne 0 ]; then
    echo "compile app code failed"
    exit 1
fi
infer
if [ $? -ne 0 ]; then
    echo " execute inference failed"
    exit 1
fi
cal_acc
if [ $? -ne 0 ]; then
    echo "calculate accuracy failed"
    exit 1
fi