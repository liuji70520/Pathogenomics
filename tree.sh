#!/bin/bash

# 检查是否提供了输入目录作为命令行参数
if [ $# -lt 1 ]; then
    echo "使用方法: $0 <input_dir>"
    echo "请提供一个包含 .faa 文件的目录作为输入。"
    exit 1
fi

# 定义输入目录
input_dir="$1"

# 检查输入目录是否存在
if [ ! -d "$input_dir" ]; then
    echo "指定的输入目录不存在: $input_dir"
    exit 1
fi

# 设置工作目录为当前目录
cd "$(dirname "$0")"

# 定义输出目录，如果不存在则创建
output_dir="./tree_out"
if [ ! -d "$output_dir" ]; then
    mkdir "$output_dir"
fi

# 遍历输入目录下的所有 .faa 文件
for faa_file in "$input_dir"/*.faa; do
    base_name=$(basename "$faa_file" .faa)
    mafft_output="${output_dir}/${base_name}_aln.fasta"
    trimal_output="${output_dir}/${base_name}_AlnTrimed.fasta"
    iqtree_output="${output_dir}/${base_name}_iqtreeout/${base_name}.tree"

    # 创建 IQ-TREE 输出目录
    iqtree_dir="${output_dir}/${base_name}_iqtreeout"
    mkdir -p "$iqtree_dir"

    # MAFFT 比对
    echo "Running MAFFT on $faa_file"
    mafft --thread 8 --adjustdirection --auto "$faa_file" > "$mafft_output"
    if [ $? -ne 0 ]; then
        echo "MAFFT failed for $faa_file"
        continue # 如果 MAFFT 失败，跳过当前文件
    fi

    # Trimal 修剪
    echo "Running Trimal on $mafft_output"
    trimal -in "$mafft_output" -out "$trimal_output" -gappyout
    if [ $? -ne 0 ]; then
        echo "Trimal failed for $mafft_output"
        continue # 如果 Trimal 失败，跳过当前文件
    fi

    # IQ-TREE 构建树
    echo "Running IQ-TREE on $trimal_output"
    iqtree -s "$trimal_output" -nt 8 -m MFP -bb 1000 -alrt 1000 -pre "$iqtree_output"
    if [ $? -ne 0 ]; then
        echo "IQ-TREE failed for $trimal_output"
        continue # 如果 IQ-TREE 失败，跳过当前文件
    fi

    echo "Processing of $faa_file completed successfully."
done

echo "Batch processing completed."
