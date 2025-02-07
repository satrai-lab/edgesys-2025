#!/bin/bash
cluster=1
for i in $(cat node_list)
do
	target="<cluster_name>"
	replacement="cluster${cluster}"

	input_file="run.sh"
	newname="run${cluster}.sh"
	temp_file="temp_file.sh"

	sed "s/$target/$replacement/g" "$input_file" > "$temp_file"

	mv "$temp_file" "$newname"
	ssh root@$i 'bash -s' < "$newname" &
	cluster=$((cluster+1))
done