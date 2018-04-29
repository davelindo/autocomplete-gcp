#!/usr/local/bin/python

import json
import pandas as pd
from elasticsearch import Elasticsearch, helpers
import numpy as np

index_name = "product_list"

es = Elasticsearch(['elasticsearch:9200'], sniff_on_start=True)
f = open("./products.json", encoding='utf-8')


def insert_records():
    print("Inserting %s entries to Elasticsearch" %
          len(data_df.to_dict('records')))
    helpers.bulk(es, remove_empty_from_dict(data_df.to_dict('records')),
                 index=index_name, chunk_size=1000,
                 request_timeout=200, doc_type="product", raise_on_error=False)
    return


def remove_empty_from_dict(d):
    if type(d) is dict:
        return dict((k, remove_empty_from_dict(v)) for k, v in d.items() if v and remove_empty_from_dict(v))
    elif type(d) is list:
        return [remove_empty_from_dict(v) for v in d if v and remove_empty_from_dict(v)]
    else:
        return d


def create_index():
    if es.indices.exists(index_name):
        print("deleting '%s' index..." % (index_name))
        res = es.indices.delete(index=index_name)
    request_body = {
        "settings": {
            "number_of_shards": 25,
            "number_of_replicas": 0,
            "analysis": {
                "filter": {
                    "autocomplete_filter": {
                        "type":     "edge_ngram",
                        "min_gram": 1,
                        "max_gram": 20
                    }
                },
                "analyzer": {
                    "autocomplete": {
                        "type":      "custom",
                        "tokenizer": "standard",
                        "filter": [
                            "lowercase",
                            "autocomplete_filter"
                        ]
                    }
                }
            }
        }
    }
    mapping_body = {
        "product": {
            "properties": {
                "name": {
                    "type":     "text",
                    "analyzer": "autocomplete"
                }
            }
        }
    }

    print("creating '%s' index..." % (index_name))
    res = es.indices.create(index=index_name, body=request_body)
    print(" response: '%s'" % (res))
    print("applying autocomplete filter to: %s" % index_name)
    res = es.indices.put_mapping(index=index_name, body=mapping_body, doc_type="product")
    return


data = json.load(f)
data_df = pd.DataFrame(data)
data_df = data_df[~data_df['name'].isnull()]
data_df.drop_duplicates(subset=['name', 'sku'], keep='first')

create_index()
insert_records()
