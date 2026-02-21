#!/bin/bash

dir="/Users/racus/Virtual Machines.localized"

find_vmx() {
    local vm_folder="$1"
    find "$vm_folder" -name "*.vmx" -maxdepth 1 | head -1
}

vm_count=$(ls "$dir" | grep "\.vmwarevm" | wc -l | tr -d ' ')

vm_list=$(ls "$dir" | grep "\.vmwarevm")

while getopts "ud" opt; do
    case $opt in
        u)
            echo "Найдено VM: $vm_count"
            echo "$vm_list" | while read vm; do
                vm_folder="$dir/$vm"
                vmx_file=$(find_vmx "$vm_folder")
                
                if [ -n "$vmx_file" ]; then
                    vmrun start "$vmx_file" nogui
                else
                    echo "Ошибка: .vmx не найден в $vm_folder"
                fi
            done

            echo "Ожидание загрузки..."

            echo "$vm_list" | while read vm; do
                vm_folder="$dir/$vm"
                vmx_file=$(find_vmx "$vm_folder")
                
                if [ -n "$vmx_file" ]; then
                    ip=$(vmrun getGuestIPAddress "$vmx_file" -wait 2>/dev/null)
                    vm_name=$(echo "$vm" | cut -d' ' -f1)
                    
                    if [ -n "$ip" ]; then
                        printf "%-15s %s\n" "$vm_name:" "$ip"
                    else
                        echo "$vm_name: IP не получен"
                    fi
                fi
            done
            ;;
            
        d)
            echo "Остановка..."
            echo "$vm_list" | while read vm; do
                vm_folder="$dir/$vm"
                vmx_file=$(find_vmx "$vm_folder")
                
                if [ -n "$vmx_file" ]; then
                    echo "Останавливаю: $vm"
                    vmrun stop "$vmx_file" soft
                else
                    echo "Ошибка: .vmx не найден в $vm_folder"
                fi
            done
            ;;
            
        \?)
            echo "Неверный флаг!"
            echo "Использование: $0 [-u] для запуска | [-d] для остановки"
            exit 1
            ;;
    esac
done

if [ $OPTIND -eq 1 ]; then
    echo "Укажите флаг: -u (запуск) или -d (остановка)"
    exit 1
fi