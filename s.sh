#!/bin/bash

# 检查参数
if [[ $# -lt 2 ]]; then
    echo "必须提供开始时间和结束时间两个参数，如：$0 2022-01-01 $(date +%Y-%m-%d)"
    exit 1
fi

# 定义时间恢复函数
resetTime() {
    # 恢复系统时间（需 root 权限）
    sudo sntp -sS time.apple.com || sudo ntpdate time.apple.com
}

# 解析时间戳（兼容 Linux）
START_DAY=$(date --date="$1" +%s)
END_DAY=$(date --date="$2" +%s)

modify() {
    echo "处理中……"
    while (( START_DAY <= END_DAY )); do
        # 生成当前日期字符串（格式：MMDDHHMMYYYY）
        cur_day=$(date -d "@$START_DAY" +"%m%d%H%M%Y")
        
        # 修改系统时间（需 root 权限）
        sudo date -s "@$START_DAY"
        
        # 提交到 GitHub 日历
        commit="${cur_day} https://github.com/lelehub/fill-github-calendar-heatmap"
        echo "$commit" > log.txt
        git add .
        git commit -m "$commit"
        
        # 时间递增（1 天）
        START_DAY=$((START_DAY + 86400))
    done
    echo "处理完成"
}

# 执行主逻辑
modify

exit 0