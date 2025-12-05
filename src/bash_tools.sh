#!/usr/bin/env bash
set -euo pipefail                     # 脚本一出错就退出，超级安全
IFS=$'\n\t'                           # 防止文件名带空格被拆开
# ====================== 颜色定义（只定义一次） ======================
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# =====================定义日志文件名==========================
filename=$(basename "$0")
LOGFILE="./log/${filename}.log"
mkdir -p "$(dirname "$LOGFILE")"
# ====================== 日志函数终极版 ======================

log_info() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "==============================\n${CYAN}[ ${timestamp} ] ${BLUE}INFO  $1${NC}" | tee -a "$LOGFILE"
}

log_success() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${CYAN}[ ${timestamp}] ${GREEN}SUCCESS  $1${NC}" | tee -a "$LOGFILE"
}

log_error() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${CYAN}[ ${timestamp}] ${RED}ERROR  $1${NC}" | tee -a "$LOGFILE" >&2
}
# ==================== 执行命令神器（取代 run_cmd） ====================
run_cmd() {
    local description="$1"
    shift
    local cmd="$*"

    log_info "$description"

    if "$@"; then
        log_success "$description"
        return 0
    else
        local exit_code=$?
        log_error "$description（退出码: $exit_code）"
        return $exit_code
    fi
}

# log_info "步骤开始"
# log_success "执行成功"
# log_error "执行失败"
# run_cmd "安装pip..." sudo pacman -Sy --needed --noconfirm python-pip 
# ======================LOCAL_IP=========================
LOCAL_IP=$(ip route get 1 | awk '{print $7; exit}')
