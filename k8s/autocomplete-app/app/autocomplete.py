#!/usr/local/bin/python
from flask import Flask, request, make_response, render_template
import json
import redis
import html
import logging

from elasticsearch import Elasticsearch
es = Elasticsearch(['elasticsearch:9200'], sniff_on_start=True,
                   sniff_on_connection_fail=True, max_retries=2)
r = redis.Redis(host='redis-slave', port=6379, decode_responses=True)

app = Flask(__name__)
app.logger.setLevel(logging.ERROR)
log = logging.getLogger('werkzeug')
log.setLevel(logging.ERROR)


@app.route('/query', methods=['POST', 'GET'])
def get_suggestions_es_redis():
    if request.args.get('q') != None:
        query = html.unescape(request.args.get('q')).lower()
        suggestions = r.get(query)
        if suggestions is None:
            query_name_contains = {
                "query": {
                    "match": {
                        "name": {
                            "query": query,
                            "fuzziness": "AUTO"
                        }
                    }
                }
            }
            try:
                suggestions = es.search(
                    index="product_list", doc_type="product", body=query_name_contains)
                suggestions = [s['_source']['name']
                               for s in suggestions['hits']['hits']]
                suggestions = json.dumps(suggestions)
                w = redis.Redis(host='redis-master', port=6379,
                                decode_responses=True)
                #Expire redis cache in 5 hours
                w.set(query, suggestions, ex=18000)
            except Exception as e:
                print("failed to search Elasticsearch: %s" % e)

        if suggestions is not None:
            rst = make_response(suggestions)
        else:
            rst = make_response('')
        rst.headers['Access-Control-Allow-Origin'] = '*'
        return rst
    else:
        rst = make_response('')
        rst.headers['Access-Control-Allow-Origin'] = '*'
        return rst


@app.route('/healthcheck', methods=['POST', 'GET'])
def healthcheck():
    try:
        response = r.client_list()
    except redis.ConnectionError as e:
        return json.dumps({"error": e}), 500
    rst = make_response('')
    rst.headers['Access-Control-Allow-Origin'] = '*'
    return rst


@app.route('/', methods=['GET'])
def index():
    return render_template("index.html")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, threaded=True)
