#!/bin/bash
cd tpcds_data_generate

sudo bash compile_tools.sh
sudo bash run.sh

cd ../

python3 -m pip install -r requirements.txt
cd tpcds-populate
python3 populate_mysql.py