if [ $# -lt 3 ]
then
    usage="Usage: bash scripts/run_eval_onnx.sh \
<DATA_PATH> <COCO_ROOT> <ONNX_MODEL_PATH> \
[<INSTANCES_SET>] [<DEVICE_TARGET>] [<CONFIG_PATH>]"
    echo "$usage"
exit 1
fi

get_real_path(){
  if [ "${1:0:1}" == "/" ]; then
    echo "$1"
  else
    echo "$(realpath -m $PWD/$1)"
  fi
}

DATA_PATH=$1
COCO_ROOT=$2
ONNX_MODEL_PATH=$3
INSTANCES_SET=${4:-'annotations/instances_{}.json'}
DEVICE_TARGET=${5:-"GPU"}
CONFIG_PATH=${6:-"config/ssd_vgg16_config_gpu.yaml"}

echo $ONNX_MODEL_PATH
echo $INSTANCES_SET
echo $DEVICE_TARGET
echo $CONFIG_PATH

python eval_onnx.py \
    --dataset coco \
    --data_path $DATA_PATH \
    --coco_root $COCO_ROOT \
    --instances_set $INSTANCES_SET \
    --file_name $ONNX_MODEL_PATH \
    --device_target $DEVICE_TARGET \
    --config_path $CONFIG_PATH \
    --batch_size 1 \
    &> eval.log &
