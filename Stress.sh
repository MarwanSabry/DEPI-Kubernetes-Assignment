#!/bin/bash
# add pods names here
web_pods=("web-server-deployment-5b5458cdf8-5c44l" "web-server-deployment-5b5458cdf8-dvbgx" "web-server-deployment-5b5458cdf8-v984c")
for pod in "${web_pods[@]}"; do
  # Run stress on 8 CPUs for 10 minutes
  kubectl exec -it $pod -- stress --cpu 8 --timeout 600 
done