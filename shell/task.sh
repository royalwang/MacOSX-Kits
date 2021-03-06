# 环境
. ~/.bashrc

# 日期输出
function task_kits_date() {
    d=$(date "+%Y-%m-%d %H:%M:%S,000")
    echo -e "\n\n$d: $1\n-----\n"
}

# RunAtLoad
function task_load() {
    task_kits_date $FUNCNAME
    # 重置ssh
    ssh.reset
    # 启动代理
    proxy.start
}

function task_hourly() {
    task_kits_date $FUNCNAME
    # PAC更新
    kits_pac_update
}

# 其它
# 备份
function task_backup() {
    task_kits_date $FUNCNAME
    # 延时一定时间，防止当系统刚从睡眠中恢复时网络不正常，备份失败。
    echo 'Sleep 30s...'
    sleep 30
    kits.backup --quiet --no-exact-progress
}