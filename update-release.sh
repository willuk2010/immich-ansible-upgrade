#!/bin/sh

#Set your GitHub username and repo name
repo="immich-app/immich"

#Get the list of tags from the repository (sorted by creation date)
tags=$(curl --silent -m 10 --connect-timeout 5 "https://api.github.com/repos/$repo/tags")

#Check if the curl request was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch tag information from GitHub."
    exit 1
fi

#Check if tags are empty or if no tags are found
if [ -z "$tags" ] || [ "$(echo "$tags" | jq '. | length')" -eq 0 ]; then
    echo "Error: No tags found in the repository $repo."
    exit 1
fi

#Extract the latest tag (first tag in the list)
tag=$(echo "$tags" | jq -r '.[0].name')

#Check if jq failed to extract the tag
if [ -z "$tag" ]; then
    echo "Error: Could not extract tag_name from the response."
    echo "Response was: $tags" # Show the raw response
    exit 1
fi

printf "Current content of install.env: "
cat install.env |grep REPO_TAG

printf "Current content of install.env: "
cat .env |grep REPO_TAG

#Update the install.env file with the latest tag
sed -i -E "s/REPO_TAG=.*/REPO_TAG=$tag/" install.env

#Update the .env file with the latest tag (same as above)
#If REPO_TAG is empty or missing, it will be updated or added
sed -i -E "/REPO_TAG=/c\REPO_TAG=$tag" .env

#Check if the sed command was successful for both files
if [ $? -eq 0 ]; then
    echo "Both install.env and .env updated successfully with tag: $tag"
else
    echo "Error: Failed to update install.env or .env"
    exit 1
fi

#Print updated content of install.env and .env (for debugging)
printf "Updated content of install.env: "
cat install.env |grep REPO_TAG

printf "Updated content of install.env: "
cat .env |grep REPO_TAG
