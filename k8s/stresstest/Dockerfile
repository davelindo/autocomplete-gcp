FROM oba11/vegeta:latest

ENV TARGET_HOST GET test.com/
ENV TIMEOUT 5s
ENV RATE 300
ENV DURATION 1m

RUN mkdir /app/ && \
    apk update && \
    apk add wget bc && \
    wget https://github.com/dwyl/english-words/raw/master/words.txt --no-check-certificate -O /app/targets && \
    apk del wget

COPY ./app /app/
RUN ["chmod", "+x", "/app/run.sh"]
WORKDIR /app/
CMD [ "/app/run.sh" ]