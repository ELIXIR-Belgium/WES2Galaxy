#!/bin/bash

pip install -r requirements.txt

galaxy_instance="http://localhost:8080"
galaxy-wait -g $galaxy_instance

echo "Loading workflow" 
python "/startingWorkflow.py"
