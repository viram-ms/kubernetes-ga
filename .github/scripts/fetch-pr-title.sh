#!/bin/bash

# Get the pull request title
PR_TITLE="${GITHUB_EVENT_NAME}"
echo $PR_TITLE
# Define the environment names
# ENV_NAMES=("sqa3" "stg" "prod")
ENV_NAMES=($(ls -1 --color=never environments/fast  | grep -v ":" | grep -v '^[[:space:]]*$'))
# SVC_NAMES=("identity" "event" "auditlog" "authentication" "proxy" "email" "saml" "rbac")
SVC_NAMES=($(ls -1 --color=never charts  | grep -v ":" | grep -v '^[[:space:]]*$'))
# SILO_NAMES=("fast")
SILO_NAMES=($(ls -1 --color=never environments  | grep -v ":" | grep -v '^[[:space:]]*$'))


# Loop through the environment names
for ENV_NAME in "${ENV_NAMES[@]}"; do
 # Check if the environment name is in the pull request title
    if [[ $PR_TITLE == "$ENV_NAME" ]]; then
        echo "environment: $ENV_NAME" >> "$GITHUB_ENV"
        break
    fi
done

for SVC_NAME in "${SVC_NAMES[@]}"; do
 # Check if the environment name is in the pull request title
    if [[ $PR_TITLE == "$SVC_NAME" ]]; then
        echo "service: $SVC_NAME" >> "$GITHUB_ENV"
        break
    fi
done

for SILO_NAME in "${SILO_NAMES[@]}"; do
 # Check if the environment name is in the pull request title.
    if [[ $PR_TITLE == "$SILO_NAME" ]]; then
        echo "silo: $SILO_NAME" >> "$GITHUB_ENV"
        break
    fi
done