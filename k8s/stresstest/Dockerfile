FROM oba11/vegeta:latest

ENV TARGET_HOST GET test.com/
ENV TIMEOUT 5s
ENV RATE 300
ENV DURATION 1m

COPY ./app /app/
RUN ["chmod", "+x", "/app/run.sh"]

RUN apk update && \
    apk add git jq perl && \
    cd /tmp/ && \
    git clone https://github.com/BestBuyAPIs/open-data-set.git --depth 1 && \
    cd open-data-set && \
    cat products.json | jq .\[\].name -r | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g' | perl -pe 's/\s+/\n/g' | sort | uniq > /app/targets && \
    rm -rf /tmp/open-data-set && \
    apk del git jq perl

WORKDIR /app/
CMD [ "/app/run.sh" ]