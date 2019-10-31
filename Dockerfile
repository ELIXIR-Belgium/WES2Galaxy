
# to build the docker image, go to root of training repo and
#    docker build -t containername -f Dockerfile .
#
# to run image:
#    docker run -p "8080:80" -t containername 

FROM bgruening/galaxy-stable:19.01
LABEL maintainer='Bert Droesbeke'
LABEL software="WES2Galaxy"
LABEL maintainer.organisation='ELIXIR Belgium'

ENV GALAXY_CONFIG_BRAND "Galaxy Container"

ADD bin/startingWorkflow.py /startingWorkflow.py
ADD bin/docker-install-workflow.sh /setup-workflow.sh
ADD bin/starter-service.sh /starter-service.sh
ADD /requirements.txt /requirements.txt 
ADD /workflow /workflowDir

RUN mkdir /output \
  && chmod +x /setup-workflow.sh \
  && chmod +x /starter-service.sh
RUN /setup-workflow.sh

ENTRYPOINT [ "/starter-service.sh" ]