#!/bin/sh
git clone https://github.com/BestBuyAPIs/open-data-set.git --depth 1  
cd open-data-set
python3 /app/dataloader.py
exit 0