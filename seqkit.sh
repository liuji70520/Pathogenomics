#!/bin/bash

# 检查参数数量
if [ $# -lt 2 ] || [ $# -gt 3 ]; then
    echo "使用方法: $0 <fasta_file> <id_dir> [a|n]"
    echo "请提供FASTA文件路径和ID文件所在的目录路径。"
    echo "可选的第三个参数 'a' 代表输出文件后缀为 .faa，'n' 代表 .fna（默认）。"
    exit 1
fi

# 获取用户输入的FASTA文件路径
fasta_file="$1"

# 获取用户输入的ID文件目录路径
id_dir="$2"

# 设置输出文件后缀，默认为 'fna'
output_suffix="fna"
if [ $# -eq 3 ]; then
    if [ "$3" == "a" ]; then
        output_suffix="faa"
    elif [ "$3" == "n" ]; then
        output_suffix="fna"
    else
        echo "无效的第三个参数：$3. 请使用 'a' 或 'n'."
        exit 1
    fi
fi

# 确保提供的FASTA文件路径是存在的
if [ ! -f "$fasta_file" ]; then
    echo "错误：提供的FASTA文件路径不存在或不是一个文件。"
    exit 1
fi

# 确保提供的ID文件目录路径是存在的
if [ ! -d "$id_dir" ]; then
    echo "错误：提供的ID文件目录路径不存在或不是一个目录。"
    exit 1
fi

# 进入ID文件目录
cd "$id_dir"

# 找到ID目录下的所有病毒科子目录
find . -mindepth 1 -maxdepth 1 -type d | while read family_dir; do
    # 检查当前病毒科子目录是否含有id.txt文件
    if [ -f "${family_dir}/id.txt" ]; then
        # 构造输出文件的完整路径
        output_file="${family_dir}/$(basename "${family_dir}").$output_suffix"
        
        # 使用seqkit grep命令提取序列，并将结果保存到病毒科子目录中
        seqkit grep -f "${family_dir}/id.txt" "$fasta_file" > "$output_file"
    fi
done

echo "所有病毒科的序列文件已在各自的子目录中生成，文件后缀为 .$output_suffix。"
