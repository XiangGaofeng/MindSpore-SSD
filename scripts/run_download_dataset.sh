if [ $# != 2 ]
then
    echo "Usage: bash run_download_dataset.sh [DATASET] [CONFIG_PATH]"
exit 1
fi

get_real_path(){
  if [ "${1:0:1}" == "/" ]; then
    echo "$1"
  else
    echo "$(realpath -m $PWD/$1)"
  fi
}

DATASET=$1
CONFIG_PATH=$(get_real_path $2)
echo $DATASET
echo $CONFIG_PATH

BASE_PATH=$(cd "`dirname $0`" || exit; pwd)
cd $BASE_PATH/../ || exit

python src/download_dataset.py \
    --dataset=$DATASET \
    --config_path=$CONFIG_PATH > download_dataset_log.txt 2>&1 &
cd ..
