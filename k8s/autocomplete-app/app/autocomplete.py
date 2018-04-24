#!/usr/local/bin/python
from flask import Flask, request, make_response, render_template
import json
import redis
import html

from elasticsearch import Elasticsearch
es = Elasticsearch(['elasticsearch:9200'], sniff_on_start=True)
r = redis.Redis(host='redis-slave', port=6379, decode_responses=True)

app = Flask(__name__)


@app.route('/query', methods=['POST', 'GET'])
def get_suggestions_es_redis():
    if request.args.get('q') != None:
        query = request.args.get('q')
        suggestions = r.get(query)
        if suggestions is None:
            query_name_contains = {
                'query': {
                    'match': {
                        'name': {
                            'query': str(html.unescape(query)), 
                            'fuzziness': 'AUTO', 
                            "operator": "and"
                        }
                    }
                }
            }
            print("querying ES for %s" % str(html.unescape(query)))
            suggestions = es.search(
                index="product_list", doc_type="product_name", body=query_name_contains)
            suggestions = [s['_source']['name']
                           for s in suggestions['hits']['hits']]
            suggestions = json.dumps(suggestions)
            w = redis.Redis(host='redis-master', port=6379,
                            decode_responses=True)
            w.set(query, suggestions)
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
    rst = make_response('')
    rst.headers['Access-Control-Allow-Origin'] = '*'
    return rst


@app.route('/', methods=['GET'])
def index():
    return render_template("index.html")
