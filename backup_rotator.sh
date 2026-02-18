#!/bin/bash

backup_dir=""
backup_num=5
verbose=0

while getopts "d:n:vh" opt; do
case $opt in
d) 
backup_dir=$OPTARG
;;
n) 
backup_num=$OPTARG
;;
v) 
verbose=1
;;
h)
echo '
-d — директория для бекапа (обязательный)
-n — количество бекапов, которое хранить (число, по умолчанию 5)
-v — verbose режим (выводить больше информации)
-h — показать помощь
' 
exit 0
;;
\?)
echo "Неизвестный флаг"
exit 1
;;
esac
done

echo "backup_dir=$backup_dir"
echo "backup_num=$backup_num"
echo "verbose=$verbose"

if [ -z "$backup_dir" ]; then
echo "Дерриктория не указана после флага -d"
exit 2
fi

if [ ! -d "$backup_dir" ]; then
echo "Дерриктория указана с ошибкой или не существует"
exit 3
fi

ts=$(date +%Y%m%d_%H%M%S)
backup_file_name="backup_$ts.tar.gz"

tar -czf "$backup_file_name" -C "$(dirname "$backup_dir")" "$(basename "$backup_dir")"

if [ $verbose -eq 1 ]; then
echo "Cоздан backup: $backup_file_name"
echo "Размер: $(stat -c%s "$backup_file_name") байт"
fi

ls -t backup_*.tar.gz 2>/dev/null | tail -n +$(($backup_num+1)) | while read old; do
if [ $verbose -eq 1 ]; then
echo "Удаляю файл $old..."
fi
rm -rf "$old"
done 
exit 0