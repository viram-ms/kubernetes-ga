#!/bin/bash

if [ $# -eq 0 ]; then
  echo "No argument provided. Usage: $0 <your_argument>"
  exit 1
fi
# Get the pull request title
pr_title=$1
# Convert the pull request title to lowercase
lowercase_pr_title=$(echo "$pr_title" | tr '[:upper:]' '[:lower:]')
echo "$pr_title $lowercase_pr_title"
# Define the environment names
# ENV_NAMES=("sqa3" "stg" "prod")
env_names=($(ls -1 --color=never environments/fast  | grep -v ":" | grep -v '^[[:space:]]*$'))
# SVC_NAMES=("identity" "event" "auditlog" "authentication" "proxy" "email" "saml" "rbac")
# svc_names=($(ls -1 --color=never charts  | grep -v ":" | grep -v '^[[:space:]]*$'))
# SILO_NAMES=("fast")
silo_names=($(ls -1 --color=never environments  | grep -v ":" | grep -v '^[[:space:]]*$'))


# Loop through the environment names
env_found=false
for env_name in "${env_names[@]}"; do
    echo "line 23 $env_name"
 # Check if the environment name is in the pull request title
    if [[ $lowercase_pr_title == *"$env_name"* ]]; then
        echo "line 26"
        environment=$env_name
        echo "environment=$env_name" >> "$GITHUB_OUTPUT"
        env_found=true
        break
    fi
done

silo_found=false
for silo_name in "${silo_names[@]}"; do
    echo "line 43 $silo_name"
 # Check if the silo is in the pull request title.
    if [[ $lowercase_pr_title == *"$silo_name"* ]]; then
        echo "line 46"
        silo=$silo_name
        silo_found=true
        echo "silo=$silo_name" >> "$GITHUB_OUTPUT"
        break
    fi
done

echo "line 52 $service $environment $silo"

if [[ $env_found == false || $silo_found == false ]]; then
    exit 1
fi