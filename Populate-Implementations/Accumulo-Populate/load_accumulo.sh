#!/bin/bash

FACTOR=10
TOTAL_CHUNKS=100
DATA_DIR=/home/user/data
TOOLS_DIR=/home/user/trino-rhino/DSGen-software-code-3.2.0rc1/tools
mkdir -p $DATA_DIR


for (( CHUNK=1; CHUNK<=$TOTAL_CHUNKS; CHUNK++ ))
do
	echo "--------------------------------"
	echo "chunk" $CHUNK"/"$TOTAL_CHUNKS
	echo "--------------------------------"

	cd $TOOLS_DIR
        ./dsdgen -dir $DATA_DIR -sc $FACTOR -parallel $TOTAL_CHUNKS -child $CHUNK \
        	-verbose -rngseed 314159
	ls $DATA_DIR

	for TABLE in call_center catalog_page customer_address customer customer_demographics date_dim dbgen_version household_demographics income_band item promotion reason ship_mode store time_dim warehouse web_page web_sales web_site
	do
		FILENAME=$TABLE\_$CHUNK\_$TOTAL_CHUNKS.dat
        	if [ ! -f $DATA_DIR/$FILENAME ] ; then
			continue
		fi
		sed -i -e 's/^|/\\N|/' -e 's/||/|\\N|/g' -e 's/||/|\\N|/g' \
                	-e 's/|$/|/' $DATA_DIR/$FILENAME

		$ACCUMULO_HOME/bin/accumulo com.accumulopop.Main $TABLE $FILENAME


		rm $DATA_DIR/$FILENAME
	done
done