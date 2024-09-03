#!/bin/bash

ARC_NAME=REGISTRY_NAME # change to your registry
PURGE_CMD="acr purge \
  --filter '.*:^\d+\.\d+\.\d+rc\d+$' \ # multiple filters can be added here with different regex expressions
  --filter 'specific_repository:.*' \
  --keep 10 \
  --ago 180d --untagged"

az acr task create --name weeklyPurgeTaskStaging \
  --cmd "$PURGE_CMD" \
  --schedule "0 1 * * Mon" \ # weekly schedule, every Monday night
  --registry $ARC_NAME \
  --context /dev/null \
  --cpu 2