# Galaxy workflow execution using WES schemas

## Building a Galaxy image supporting the workflow

A Galaxy 19.01 container will be decorated with the necessary tools to run the workflow. This is done by taking 

```sh
docker build -t containername -f Dockerfile .
```

## Mapping the inputfiles to the correct input steps 