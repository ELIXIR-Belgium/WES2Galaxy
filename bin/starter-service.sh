#!/bin/bash
set -e

# set API key and galaxy instance

API_KEY=${GALAXY_DEFAULT_ADMIN_KEY:fakekey}
galaxy_instance="http://localhost:8080"

# setting up conda 
GALAXY_CONDA_PREFIX=/tool_deps/_conda export PATH=$GALAXY_CONDA_PREFIX/bin/:$PATH

startup &
galaxy-wait -g $galaxy_instance

echo "Loading workflow" 
python "/bin/startingWorkflow.py"
