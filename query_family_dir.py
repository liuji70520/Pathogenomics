import os
import sys

def main():
    # 检查命令行参数数量
    if len(sys.argv) < 3 or len(sys.argv) > 4:
        print("使用方法: python script.py <query_id_file> <query_family_file> [<output_dir>]")
        sys.exit(1)
    
    # 从命令行获取文件路径和输出目录
    query_id_file = sys.argv[1]
    query_family_file = sys.argv[2]
    output_dir = sys.argv[3] if len(sys.argv) == 4 else './'  # 默认为当前目录

    # 读取文件内容
    try:
        with open(query_family_file, 'r') as f:
            families = [line.strip() for line in f]
        
        with open(query_id_file, 'r') as f:
            ids = [line.strip() for line in f]
        
        if len(families) != len(ids):
            raise ValueError("两个文件的行数不一致")
    except IOError as e:
        print(f"文件读取错误: {e}")
        sys.exit(1)

    # 创建家族到ID的映射
    family_to_ids = {}
    for family, id_ in zip(families, ids):
        if family not in family_to_ids:
            family_to_ids[family] = []
        family_to_ids[family].append(id_)

    # 确保输出目录存在
    os.makedirs(output_dir, exist_ok=True)

    # 写入id.txt到各个家族的子文件夹
    for family, ids in family_to_ids.items():
        family_path = os.path.join(output_dir, family)
        os.makedirs(family_path, exist_ok=True)
        id_file_path = os.path.join(family_path, 'id.txt')
        with open(id_file_path, 'w') as f:
            for id_ in ids:
                f.write(id_ + '\n')

    print(f"文件夹和ID文件在'{output_dir}'文件夹中生成完毕")

if __name__ == "__main__":
    main()
