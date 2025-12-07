#!/usr/bin/bash
# >>> safe_mode_begin
set -euo pipefail
# <<< safe_mode_end

IFS=$'\n\t'                           # 防止文件名带空格被拆开
# >>> color_definition_begin
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'
BOLD='\033[1m'
NC='\033[0m' # No Color
# <<< color_definition_end

# >>> log_filename_definition_begin
filename=$(basename "$0")
LOGFILE="./log/${filename}.log"
mkdir -p "$(dirname "$LOGFILE")"
# <<< log_filename_definition_end
# >>> log_function_ultimate_begin
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
# log_info "步骤开始"
# log_success "执行成功"
# log_error "执行失败"
# <<< log_function_ultimate_end
# >>> run_cmd_ultimate_begin
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
# run_cmd "安装pip..." sudo pacman -Sy --needed --noconfirm python-pip 
# <<< run_cmd_ultimate_end

# >>> local_ip_ultimate_begin
LOCAL_IP=$(ip route get 1 | awk '{print $7; exit}')
# <<< local_ip_ultimate_end
