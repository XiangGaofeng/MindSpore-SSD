if [ $# != 2 ]
then
    echo "Usage: bash run_export.sh [CONFIG_PATH] [FILE_FORMAT]"
exit 1
fi

get_real_path(){
  if [ "${1:0:1}" == "/" ]; then
    echo "$1"
  else
    echo "$(realpath -m $PWD/$1)"
  fi
}

FILE_FORMAT=$2
CONFIG_PATH=$(get_real_path $1)

echo $FILE_FORMAT
echo $CONFIG_PATH

if [ ! -f $CONFIG_PATH ]
then
    echo "error: CONFIG_PATH=$CONFIG_PATH is not a file"
exit 1
fi

BASE_PATH=$(cd "`dirname $0`" || exit; pwd)
cd $BASE_PATH/../ || exit

echo "start export using $CONFIG_PATH"
python export.py \
    --config_path $CONFIG_PATH \
    --file_format $FILE_FORMAT > log.txt 2>&1 &
cd ..
