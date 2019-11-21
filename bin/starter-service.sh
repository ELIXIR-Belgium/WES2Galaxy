#!/bin/bash
echo "Starting Galaxy"
startup &
#pip install -r requirements.txt

galaxy_instance="http://localhost:8080"
galaxy-wait -g $galaxy_instance

echo "Loading workflow" 
#python "/bin/startingWorkflow.py"
