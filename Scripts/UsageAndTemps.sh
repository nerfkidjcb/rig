#!/bin/bash

# Function to get CPU usage
get_cpu_usage() {
    cpu_usage=$(mpstat 1 1 | awk '/Average/ && $3 ~ /[0-9.]+/ { print 100 - $12"%"}')
    echo "$cpu_usage"
}

# Function to get CPU temperature
get_cpu_temp() {
    cpu_temp=$(sensors | awk '/Tctl/ {print $2}')
    echo "$cpu_temp"
}

# Function to get CPU current clock speed
get_cpu_clock() {
    cpu_clock=$(awk '/MHz/ {print $4; exit}' /proc/cpuinfo)
    cpu_clock_ghz=$(echo "scale=2; $cpu_clock / 1000" | bc 2>/dev/null)
    if [ -z "$cpu_clock_ghz" ]; then
        cpu_clock_ghz="N/A"
    fi
    echo "$cpu_clock_ghz"
}

# Function to get RAM usage
get_ram_usage() {
    ram_info=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')
    echo "$ram_info"
}

# Function to get RAM speed
get_ram_speed() {
    ram_speed=$(dmidecode --type memory | awk '/Speed:/{print $2 " " $3; exit}')
    if [ -z "$ram_speed" ]; then
        ram_speed="N/A"
    fi
    echo "$ram_speed"
}

# Function to get GPU usage and temperature for AMD GPUs
get_gpu_info() {
    if command -v rocm-smi &> /dev/null; then
        gpu_usage=$(rocm-smi --showusage | awk '/GPU/{print $3}')
        gpu_temp=$(sensors | awk '/edge/ {print $2}')
        echo "$gpu_usage"
        echo "$gpu_temp"
    else
        echo "rocm-smi not found. Please install ROCm drivers for AMD GPUs."
    fi
}

# Function to get GPU information for NVIDIA GPUs
get_nvidia_gpu_info() {
    if command -v nvidia-smi &> /dev/null; then
        gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
        gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)
        echo "$gpu_usage"
        echo "$gpu_temp°C"
    else
        echo "nvidia-smi not found. Please install NVIDIA drivers."
    fi
}

# Function to get NVIDIA VRAM usage
get_nvidia_vram_usage() {
    if command -v nvidia-smi &> /dev/null; then
        vram_usage=$(nvidia-smi | grep "MiB /" | awk '{print $9 "/" $11}')
        echo "$vram_usage"
    else
        echo "N/A"
    fi
}

# Print header
echo "==== System Information ===="
printf "%-25s\n" "CPU Usage: "
printf "%-25s\n" "CPU Temperature: "
printf "%-25s\n" "CPU Clock: "
printf "%-25s\n" "RAM Used: "
printf "%-25s\n" "RAM Speed: "
printf "%-25s\n" "GPU Usage: "
printf "%-25s\n" "GPU Temperature: "
printf "%-25s\n" "VRAM Usage: "
echo "============================"

tput cuu 9 # Move up 9 lines

# Main loop
while true; do
    # Fetch data
    cpu_usage=$(get_cpu_usage)
    cpu_temp=$(get_cpu_temp)
    cpu_clock=$(get_cpu_clock)
    ram_usage=$(get_ram_usage)
    ram_speed=$(get_ram_speed)

    # Check for NVIDIA or AMD GPU and fetch info
    if command -v nvidia-smi &> /dev/null; then
        gpu_info=$(get_nvidia_gpu_info)
        gpu_usage=$(echo "$gpu_info" | awk 'NR==1')
        gpu_temp=$(echo "$gpu_info" | awk 'NR==2')
        vram_usage=$(get_nvidia_vram_usage)
    elif command -v rocm-smi &> /dev/null; then
        gpu_info=$(get_gpu_info)
        gpu_usage=$(echo "$gpu_info" | awk 'NR==1')
        gpu_temp=$(echo "$gpu_info" | awk 'NR==2')
        vram_usage="N/A"
    else
        gpu_usage="No GPU found"
        gpu_temp="N/A"
        vram_usage="N/A"
    fi

    # Move cursor up and overwrite each line
    printf "%-25s\n" "CPU Usage: $cpu_usage  "  # Standardize output
    printf "%-25s\n" "CPU Temperature: $cpu_temp   "
    printf "%-25s\n" "CPU Clock: $cpu_clock GHz    "
    printf "%-25s\n" "RAM Used: $ram_usage         "
    printf "%-25s\n" "RAM Speed: $ram_speed        "
    printf "%-25s\n" "GPU Usage: $gpu_usage%       "
    printf "%-25s\n" "GPU Temperature: $gpu_temp    "
    printf "%-25s\n" "VRAM Usage: $vram_usage      "

    tput cuu 8  # Move cursor up 8 lines
    sleep 1
done
