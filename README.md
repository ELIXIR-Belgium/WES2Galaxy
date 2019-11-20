# Galaxy workflow execution using WES schemas

## Building a Galaxy image supporting the workflow

A Galaxy 19.01 container is decorated with the necessary tools to run the workflow. 


```sh
docker build -t containername -f Dockerfile .
```

## Workflow Execution Service (WES) API

To mimic the WES `/runs` POST call to run a workflow, following example json is used:

```json
{
    "workflow_params": {
        "inputs": [
            {
                "step": "0",
                "file": "https://raw.githubusercontent.com/bedroesb/WES2Galaxy/master/example_data/UCSC_input.bed"
            }
        ]
    },
    "workflow_url": "https://raw.githubusercontent.com/bedroesb/WES2Galaxy/Dev/example_data/Galaxy-Workflow-galaxy-intro-strands-2.ga",
    "workflow_version": "0.1",
    "workflow_type": "ga"
}

```

The attribute `inputs` contains a list of all the input files with their corresponding `filename` and workflow `step`. Note that the step number is in string format.

## Building the docker image
A Galaxy `19.01` container will be decorated with the necessary tools to run the workflow. 

To build the docker image use following command in the root directory:

```sh
docker build -t containername -f Dockerfile .
```

## Running the container

To run the container use following command:

```sh
docker run -t  containername 
```

## TO DO

*  Using a WES flask client to invoke the workflow in the galaxy container


## Problems

* How to supply the output-data in the container back to the user?\
    -> 