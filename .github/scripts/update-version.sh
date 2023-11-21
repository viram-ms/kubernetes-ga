#!/bin/bash

# Extract the version number from the Chart.yaml file
path=$1

echo $path

version=$(yq e '.version' $path/Chart.yaml)

echo $version
# Split the version number into major, minor, and patch components
IFS='.' read -ra ADDR <<< "$version"
major="${ADDR[0]}"
minor="${ADDR[1]}"
patch="${ADDR[2]}"

IFS='-' read -ra ADDDR <<< "$patch"
patchnumber="${ADDDR[0]}"

# Increment the patch component
patchnumber=$((patchnumber+1))

# Construct the new version number
new_version="$major.$minor.$patchnumber"

# Update the version number in the Chart.yaml file
# yq e ".version = \"$new_version\"" -i Chart.yaml
echo $new_version
echo "new_version=$new_version" >> "$GITHUB_ENV"