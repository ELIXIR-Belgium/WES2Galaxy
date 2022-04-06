
# to build the docker image, go to root of training repo and
#    docker build -t containername -f Dockerfile .
#
# to run image:
#    docker run -p "8080:80" -t containername 

FROM quay.io/bgruening/galaxy:20.05
LABEL maintainer='Bert Droesbeke'
LABEL software="WES2Galaxy"
LABEL maintainer.organisation='ELIXIR Belgium'

ENV GALAXY_CONFIG_BRAND "Galaxy Container"

COPY /bin /bin
COPY /workflow /workflowDir

RUN mkdir /output \
  && chmod +x -R /bin
RUN chmod 755 /bin/docker-install-workflow.sh && \
  /bin/docker-install-workflow.sh

ENTRYPOINT [ "/bin/starter-service.sh" ]