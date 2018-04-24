FROM amancevice/pandas:0.22.0-python3-alpine

RUN apk update && \
    apk add git && \
    pip3 install pandas elasticsearch

COPY ./app /app/
RUN ["chmod", "+x", "/app/run.sh"]

WORKDIR /app/
CMD [ "/app/run.sh" ]