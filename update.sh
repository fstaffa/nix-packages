#!/usr/bin/env sh

html=$(mktemp)
curl 'https://ce-installation-binaries.s3.amazonaws.com/stskeygen/index.html' > "$html"
stskeygen_json='stskeygen.json'
json_content=$(cat $stskeygen_json)
for system in $(jq -r "keys[]" $stskeygen_json)
do
    url=$(grep -o 'href="[^"]*stskeygen[^"]*gz' < "$html" | sed 's/href="//' | grep "$system"  )
    json_content=$(echo "$json_content" | jq ".$system.url=\"$url\"")
    hash=$(nix-prefetch-url --type sha256 "$url")
    json_content=$(echo "$json_content" | jq ".$system.sha256=\"$hash\"")
    version=$(echo "$url" | grep -o 'stskeygen/[^/]*/' | sed 's/stskeygen\///' | sed 's/\/$//' )
    json_content=$(echo "$json_content" | jq ".$system.version=\"$version\"")
done
echo "$json_content" > $stskeygen_json
