
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

COPY /bin /bin
COPY /requirements.txt /requirements.txt 
COPY /workflow /workflowDir

RUN pip install ephemeris -U
RUN mkdir /output \
  && chmod +x /bin/docker-install-workflow.sh \
  && chmod +x /bin/starter-service.sh
RUN /bin/docker-install-workflow.sh

ENTRYPOINT [ "/bin/starter-service.sh" ]