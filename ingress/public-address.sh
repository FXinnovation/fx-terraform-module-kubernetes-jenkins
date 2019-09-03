#!/bin/bash

public_address=$(kubectl get ingress jenkins -o json | jq '.status.loadBalancer.ingress[0].hostname' | tr -d \")

while [ "${public_address}" == "" ]
do
  sleep 60
  public_address=$(kubectl get ingress jenkins -o json | jq '.status.loadBalancer.ingress[0].hostname' | tr -d \")
done

set -e
jq -n --arg ingressaddr "${public_address}" '{"extvar":$ingressaddr}'
