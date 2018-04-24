FROM ubuntu:16.04

#install python3
RUN apt-get update -y && \
    apt-get install -y software-properties-common && \
    apt -y autoclean && \
    add-apt-repository ppa:jonathonf/python-3.6 && \
    apt-get update && \
    apt-get install -y python3.6 python3-pip git && \
    apt-get autoclean && \
    apt-get clean

# update pip and install modules
RUN python3.6 -m pip install pip --upgrade && pip install pandas elasticsearch

COPY ./app /app/
RUN ["chmod", "+x", "/app/run.sh"]

WORKDIR /app/
CMD [ "/app/run.sh" ]