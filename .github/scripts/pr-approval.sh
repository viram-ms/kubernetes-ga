#!/bin/bash

update_version() {
    # Split the version number into major, minor, and patch components
    version=$1
    path=$2
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
    yq e ".version = \"$new_version\"" -i $path/Chart.yaml
}

count=$1
path=$2
branch=$3
bucket_name="service-helm-charts"
if [[ $count == 1 ]]; then
    echo "line 3"
    
    version=$(yq e '.version' $path/Chart.yaml)
    file_key="$service-$version.tgz" 
    if aws s3api list-objects --bucket "$bucket_name" --prefix "$file_key" | grep -q "$file_key"; then
        echo "File exists in the bucket and cannot be uploaded in helm chart repository"
        exit 1
    else
        echo "File does not exist in the bucket and can be uploaded in helm chart repository"
    fi
fi

if [[ $count == 0 ]]; then
    echo "line 17"
    version=$(yq e '.version' $path/Chart.yaml)
    update_version $version $path
    new_version=$(yq e '.version' $path/Chart.yaml)
    file_key="$service-$new_version.tgz" 
    if aws s3api list-objects --bucket "$bucket_name" --prefix "$file_key" | grep -q "$file_key"; then
        echo "File exists in the bucket and cannot be uploaded in helm chart repository"
        exit 1
    else
        echo "File does not exist in the bucket and can be uploaded in helm chart repository"
    fi
    git branch
    git config --global user.email "github-actions@github.com"
    git config --global user.name "github-actions"
    git config --global pull.rebase true
    git add charts/*
    git commit -m "Helm chart for service $service will be update to version $new_version"
    git stash
    git pull origin $branch
    git push origin $branch
fi