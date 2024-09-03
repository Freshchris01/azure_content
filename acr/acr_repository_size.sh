#!/bin/bash
registry=REGISTRY_NAME # change to your registry

echo "Getting all repos..."
arr_reglist_str=`az acr repository list -n $registry -o tsv`

progress=0
total_items=$(echo "$arr_reglist_str" | wc -l)

while IFS= read -r repo; do
    ((progress++))
    printf "Calculating %d of %d: %s\n" "$progress" "$total_items" "$repo"
    az acr repository show-manifests -n $registry --only-show-errors --repository $repo --detail --query '[].{Size: imageSize}' -o tsv | awk -v repo="$repo" '{sum += $1} END {printf "%s %.2f GB\n", repo, sum /1024/1024/1024}'
done <<< "$arr_reglist_str"