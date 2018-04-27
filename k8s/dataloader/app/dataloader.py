#!/usr/local/bin/python

import json
import pandas as pd
from elasticsearch import Elasticsearch

f = open("./products.json", encoding='utf-8')

data = json.load(f)
data_df = pd.DataFrame(data)

data_df = data_df[~data_df['name'].isnull()]
data_df = data_df[['name']]
data_df = data_df.drop_duplicates()

es = Elasticsearch(['elasticsearch:9200'], sniff_on_start=True)

for record in data_df.to_dict('records'):
    es.index(index="product_list", doc_type="product_name", body=record)
