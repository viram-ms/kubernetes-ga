#!/bin/bash

update_version() {
    # Split the version number into major, minor, and patch components
    IFS='.' read -ra ADDR <<< "$1"
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
}

# Extract the version number from the Chart.yaml file
path=$1
echo $path
version=$(yq e '.version' $path/Chart.yaml)

echo $version
echo $pull_request_labels

label_names=$(echo $pull_request_labels | jq -r '.[].name')
echo $label_names
<<<<<<< HEAD

IFS=', ' read -ra labels <<< "$label_names"
echo $labels

label_found=false
for label in "${labels[@]}"; do
    echo "Label: $label"
    if [ "$label" == "bug" ]; then
        label_found=true
        update_version $version
        break
    fi
done

if [[ $label_found == "false" ]]; then
    version=$(yq e '.version' ${{ matrix.files }}/Chart.yaml)
    echo "new_version=$version" >> "$GITHUB_ENV"
fi 

yq e ".version = \"${{ env.new_version }}\"" -i ${{ matrix.files }}/Chart.yaml
=======

IFS=', ' read -ra labels <<< "$label_names"
echo $labels

label_found=false
for label in "${labels[@]}"; do
    echo "Label: $label"
    if [ "$label" == "bug" ]; then
        label_found=true
        update_version $version
        break
    fi
done

if [[ $label_found == "false" ]]; then
    version=$(yq e '.version' ${{ matrix.files }}/Chart.yaml)
    echo "new_version=$version" >> "$GITHUB_ENV"
fi 

>>>>>>> 1f7e19a (service deployment to fast sqa3 (#10))


