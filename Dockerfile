
# to build the docker image, go to root of training repo and
#    docker build -t containername -f Dockerfile .
#
# to run image:
#    docker run -p "8080:80" -t --mount type=bind,source="$(pwd)"/mountDir,target=/mountDir containername 

FROM bgruening/galaxy-stable:19.01
MAINTAINER Galaxy Training Material

ENV GALAXY_CONFIG_BRAND "Galaxy Container"
ENV GALAXY_CONFIG_LIBRARY_IMPORT_DIR "/mountDir"

ADD bin/startingWorkflow.py /startingWorkflow.py
ADD bin/docker-install-workflow.sh /setup-workflow.sh
ADD bin/starter-service.sh /starter-service.sh
ADD /workflow /workflowDir

RUN /setup-workflow.sh

ENTRYPOINT ["/starter-service.sh"]
