#!/bin/bash

# 检查是否提供了正确数量的参数（1到3个）
if [ $# -lt 1 ] || [ $# -gt 3 ]; then
    echo "使用方法: $0 <our_faa_dir> <background_dir> [combined_dir]"
    echo "如果combined_dir未指定，将使用当前目录下的'our_background_combined'文件夹。"
    exit 1
fi

# 定义包含自己提供的序列的目录
our_faa_dir="$1"

# 定义背景序列目录
background_dir="$2"

# 定义输出目录，如果未提供，则使用当前目录下的'our_background_combined'
combined_dir=${3:-$(pwd)/our_background_combined}
log_file="${combined_dir}/unmatched_families.txt"

# 确保输出目录存在
mkdir -p "$combined_dir"

# 清空日志文件，准备写入新内容
> "$log_file"

# 遍历our_faa目录下的所有文件夹
for family_dir in "$our_faa_dir"/*/; do
    family_name=$(basename "$family_dir")
    
    # 检查是否有匹配的背景序列文件
    found=false
    for background_file in "$background_dir"/*.faa; do
        if [[ "$(basename "$background_file")" == "$family_name.faa" ]]; then  # 确保文件名完全匹配
            found=true
            output_file="$combined_dir/$family_name.faa"
            
            # 使用cat合并文件
            cat "$background_file" "$family_dir/$family_name.faa" > "$output_file"
            echo "Merged file created: $output_file"
            break
        fi
    done

    # 如果没有找到匹配的文件，记录到日志中
    if [ "$found" = false ]; then
        echo "$family_name" >> "$log_file"
    fi
done

echo "All matched files have been merged. Unmatched families are logged in $log_file"
