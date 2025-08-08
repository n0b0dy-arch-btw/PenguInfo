#!/bin/bash

# Colors
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
RESET="\033[0m"

# ASCII Art
read -r -d '' PENGUIN <<'EOF'
.
    .--.
   |o_o |
   |:_/ |
  //   \ \
 (|     | )
/'\_   _/`\
\___)=(___/ 

EOF

# System info
HOSTNAME=$(hostname)
OS=$(awk -F= '/^NAME=/{print $2}' /etc/os-release | tr -d \")
OS_VERSION=$(awk -F= '/^VERSION=/{print $2}' /etc/os-release | tr -d \")
KERNEL=$(uname -r)
CPU=$(awk -F: '/model name/{print $2; exit}' /proc/cpuinfo | sed 's/^[ \t]*//')
RAM_TOTAL=$(free -h | awk '/Mem:/{print $2}')
RAM_USED=$(free -h | awk '/Mem:/{print $3}')
DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
DISK_USE_PCT=$(df -h / | awk 'NR==2 {print $5}')
SHELL=$(basename "$SHELL")
TERM=${TERM:-"unknown"}
USER=$(whoami)
IP_ADDR=$(hostname -I | awk '{print $1}')
DATE_TIME=$(date +"%A, %B %d, %Y — %H:%M:%S")

# Package count
if command -v dpkg &>/dev/null; then
  PKG_COUNT=$(dpkg --get-selections | grep -v deinstall | wc -l)
elif command -v rpm &>/dev/null; then
  PKG_COUNT=$(rpm -qa | wc -l)
elif command -v pacman &>/dev/null; then
  PKG_COUNT=$(pacman -Q | wc -l)
else
  PKG_COUNT="N/A"
fi

# GPU detection
GPU="N/A"
if command -v lspci &>/dev/null; then
  GPU=$(lspci | grep -Ei "vga|3d" | head -n1 | cut -d ':' -f3- | sed 's/^[ \t]*//')
elif command -v glxinfo &>/dev/null; then
  GPU=$(glxinfo | grep "Device:" | head -n1 | cut -d ':' -f2- | sed 's/^[ \t]*//')
fi

# Random quote/message
QUOTES=(
  "Keep pushing your limits!"
  "Every day is a new opportunity."
  "Code is like humor. When you have to explain it, it’s bad."
  "Stay curious, stay humble."
  "Debugging is like being the detective in a crime movie."
)
RANDOM_QUOTE=${QUOTES[$RANDOM % ${#QUOTES[@]}]}

# Print info with ASCII art and improved layout
echo -e "${CYAN}$PENGUIN${RESET}"
echo -e "${MAGENTA}═══════════════════════════════════════════════${RESET}"

printf "  ${GREEN}%-18s${RESET} %s\n" "User:" "$USER"
printf "  ${GREEN}%-18s${RESET} %s\n" "Hostname:" "$HOSTNAME"
printf "  ${GREEN}%-18s${RESET} %s %s\n" "Operating System:" "$OS" "$OS_VERSION"
printf "  ${GREEN}%-18s${RESET} %s\n" "Kernel Version:" "$KERNEL"

echo -e "${MAGENTA}───────────────────────────────────────────────${RESET}"

printf "  ${GREEN}%-18s${RESET} %s\n" "CPU Model:" "$CPU"
printf "  ${GREEN}%-18s${RESET} %s\n" "GPU Model:" "$GPU"
printf "  ${GREEN}%-18s${RESET} %s / %s\n" "RAM Usage:" "$RAM_USED" "$RAM_TOTAL"
printf "  ${GREEN}%-18s${RESET} %s / %s (${YELLOW}%s${RESET} used)\n" "Disk Usage:" "$DISK_USED" "$DISK_TOTAL" "$DISK_USE_PCT"

echo -e "${MAGENTA}───────────────────────────────────────────────${RESET}"

printf "  ${GREEN}%-18s${RESET} %s\n" "Default Shell:" "$SHELL"
printf "  ${GREEN}%-18s${RESET} %s\n" "Terminal:" "$TERM"
printf "  ${GREEN}%-18s${RESET} %s\n" "IP Address:" "$IP_ADDR"
printf "  ${GREEN}%-18s${RESET} %s\n" "Packages Installed:" "$PKG_COUNT"
printf "  ${GREEN}%-18s${RESET} %s\n" "Date & Time:" "$DATE_TIME"

echo -e ""
echo -e "${YELLOW}💬  $RANDOM_QUOTE${RESET}"
