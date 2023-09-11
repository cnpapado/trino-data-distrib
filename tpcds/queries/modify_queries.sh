#!/bin/bash

QUERY_FILE=$1
OUT_FILE=$2
cp $QUERY_FILE $OUT_FILE

TABLE_MAPPING="call_center:postgres            
catalog_page:postgres           
catalog_returns:postgres        
catalog_sales:postgres          
customer:postgres       
customer_address:postgres       
customer_demographics:postgres  
date_dim:postgres                         
household_demographics:postgres 
income_band:postgres            
inventory:postgres              
item:postgres                   
promotion:mysql              
reason:mysql                 
ship_mode:mysql              
store:mysql                  
store_returns:mysql          
store_sales:mysql            
time_dim:mysql               
warehouse:mysql              
web_page:mysql               
web_returns:mysql            
web_sales:mysql              
web_site:mysql"

for mapping in $TABLE_MAPPING; do
    TABLE_OLD=$(echo $mapping | cut -d':' -f1)
    DB=$(echo $mapping | cut -d':' -f2)

    case $DB in
    "mysql")
        TABLE_NEW=mysql.tpcds_full_schema.$TABLE_OLD ;;
    "postgres")
        TABLE_NEW=postgres.public.$TABLE_OLD ;;
    "accumulo")
        echo "unimplemented"; exit ;;
    *)
        echo "unknown db mapping"; exit ;;
    esac

    echo $TABLE_OLD "->" $TABLE_NEW
    sed -i '' "s/[[:<:]]$TABLE_OLD[[:>:]]/$TABLE_NEW/g" $OUT_FILE
done           