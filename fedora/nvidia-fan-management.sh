#!/bin/env bash

setGpuFan() {
    echo "*:1[gpu:0]/GPUFanControlState=1" -a "*:1[fan-0]/GPUTargetFanSpeed=$1"
    sudo /usr/bin/nvidia-settings -a "*:1[gpu:0]/GPUFanControlState=1" -a "*:1[fan-0]/GPUTargetFanSpeed=$1"
}

for (( ; ; ))
do
    current_gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)
    
    if (( 0 <= current_gpu_temp && current_gpu_temp <= 35 ))
    then
        setGpuFan 40
    elif (( 36 <= current_gpu_temp && current_gpu_temp <= 50 ))
    then
        setGpuFan 75
    elif ((51<=current_gpu_temp && current_gpu_temp<=63))
    then
        setGpuFan 90
    elif ((64<=current_gpu_temp && current_gpu_temp<=70))
    then
        setGpuFan 100
    fi
    
    sleep 10
done
