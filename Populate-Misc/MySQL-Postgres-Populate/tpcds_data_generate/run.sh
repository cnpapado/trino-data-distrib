current_directory="$PWD"
# mkdir -p ../data # create a folder for the input data files
cd ../DSGen-software-code-3.2.0rc1/tools

# ./dsdgen -dir ../../data/ -sc 1 -verbose # generate input data of 1GB size 

sed -i -e 's/^|/\\N|/' -e 's/||/|\\N|/g' -e 's/||/|\\N|/g' -e 's/|$/|/' ../../data/*.dat # replace all empty columns with /N (MySQL only)
# ls -l
# split -l$((`wc -l < ../../data/store_sales.dat`/5)) ../../data/store_sales.dat ../../data/store_sales.split.dat -da 10 # store_sales.dat in large so we split it into 10/2=5 files
# ls -l
# mkdir -p ../../queries

touch qlist.lst # dsqgen puts all the queries from the templates dir whose name are specified in the -INPUT (qlist) file in one output file
for i in $(seq 1 1 99)
do
echo "query$i.tpl" > qlist.lst # to create each query in a different file, each time write a new template name into the qlist file
./dsqgen \
-DIRECTORY ../query_templates \
-INPUT qlist.lst \
-VERBOSE Y \
-QUALIFY Y \
-SCALE 1 \
-DIALECT netezza \
-OUTPUT_DIR ../../queries

mv ../../queries/query_0.sql ../../queries/"query$i.sql" # output of dsqgen for 1 query variant/query is query_0.sql regardless of the query template 

done
rm qlist.lst