#!/bin/bash

# Set the limit for open files
ulimit -n 32768
if [ $? -ne 0 ]; then
    echo "Failed to set ulimit."
    exit 1
fi

# Start HDFS
start-dfs.sh
if [ $? -ne 0 ]; then
    echo "Failed to start HDFS."
    exit 2
fi

# Start ZooKeeper
sudo /home/yiannos/Desktop/Projects/Installs/zookeeper/bin/zkServer.sh start
if [ $? -ne 0 ]; then
    echo "Failed to start ZooKeeper."
    exit 3
fi

# Start Accumulo
/home/yiannos/Desktop/Projects/Installs/accumulo/bin/start-all.sh
if [ $? -ne 0 ]; then
    echo "Failed to start Accumulo."
    exit 4
fi

# # Start the Accumulo proxy
# ~/Desktop/Projects/Installs/accumulo/bin/accumulo proxy -p ~/Desktop/Projects/Installs/accumulo/conf/proxy.properties
# if [ $? -ne 0 ]; then
#     echo "Failed to start Accumulo proxy."
#     exit 5
# fi

echo "All services started successfully."
