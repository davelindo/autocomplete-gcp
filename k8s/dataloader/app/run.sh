#!/bin/bash
git clone https://github.com/BestBuyAPIs/open-data-set.git
cd open-data-set
python3.6 /app/dataloader.py
exit 0