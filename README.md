# query_family_dir.py
```bash
python query_family_dir.py query_id.txt query_family.txt /path/to/output#if omit $path->default:current directory(./)
```
# seqkit.sh
```bash
chmod +x seqkit.sh
./seqkit.sh ./ /path/to/fasta_file#you should go to our_faa directory
```
# combined.sh
```bash
chmod +x seqkit.sh
./combined.sh /path/to/our_faa /path/to/background [/path/to/combined]#The output directory will default to our_background_combined folder in the current directory
```
# tree.sh
```bash
chmod +x tree.sh
./tree.sh /path/to/input_dir /path/to/desired_output_dir#If you provide only the input directory, the output will be saved in the tree_out folder under the current directory by default
```
# work 
```bash
myqsub 8 10G "tree.sh /path/to/input_dir /path/to/desired_output_dir"
```
