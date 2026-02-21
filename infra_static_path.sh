#!/bin/bash

main_path="/Users/racus/Virtual Machines.localized/DevOps Ubuntu 64-bit Arm Server 24.04.4.vmwarevm/Ubuntu 64-bit Arm Server 24.04.4.vmx"
slave1_path="/Users/racus/Virtual Machines.localized/Test1 Ubuntu 64-bit Arm Server 24.04.4 2.vmwarevm/Test Ubuntu 64-bit Arm Server 24.04.4 2.vmx"
slave2_path="/Users/racus/Virtual Machines.localized/Test2 Ubuntu 64-bit Arm Server 24.04.4 2.vmwarevm/Ubuntu 64-bit Arm Server 24.04.4 2.vmx"

while getopts "ud" opt; do
    case $opt in
        u)
            echo "Запуск инфраструктуры..."
            
            running_vms=$(vmrun list | tail -n +2)

            if ! echo "$running_vms" | grep -q "$main_path"; then
                vmrun start "$main_path" nogui
            else
                echo "Master уже запущен"
            fi
            
            if ! echo "$running_vms" | grep -q "$slave1_path"; then
                vmrun start "$slave1_path" nogui
            else
                echo "Slave1 уже запущен"
            fi
            
            if ! echo "$running_vms" | grep -q "$slave2_path"; then
                vmrun start "$slave2_path" nogui
            else
                echo "Slave2 уже запущен"
            fi

            sleep 2

            ip=$(vmrun getGuestIPAddress "$main_path" -wait 2>/dev/null)
            ip_slave1=$(vmrun getGuestIPAddress "$slave1_path" -wait 2>/dev/null)
            ip_slave2=$(vmrun getGuestIPAddress "$slave2_path" -wait 2>/dev/null)

            echo "Инфраструктура запущена!"
            vmrun list
            echo "Master ip: ${ip:-не получен}"
            echo "Slave1 ip: ${ip_slave1:-не получен}"
            echo "Slave2 ip: ${ip_slave2:-не получен}"
            exit 0
            ;;
            
        d)
            echo "Остановка инфраструктуры..."
            
            vmrun stop "$main_path" soft
            vmrun stop "$slave1_path" soft
            vmrun stop "$slave2_path" soft

            vmrun list
            echo "Инфраструктура остановлена"
            exit 0
            ;;
            
        \?)
            echo "Неверный флаг!"
            echo "Использование: $0 [-u] для запуска | [-d] для остановки"
            exit 1
            ;;
    esac
done

echo "Укажите флаг: -u (запуск) или -d (остановка)"
exit 1