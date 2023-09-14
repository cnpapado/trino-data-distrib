#!/bin/bash

# Switch to the root folder (or any other folder where the Workbench folder is)
cd ../ #only use if executing directly and not using the run_scripts.sh

# Replace with the actual path to the downloaded TPCDS Workbench
workbench_path="DSGen-software-code-3.2.0rc1"

# Check if the Workbench folder exists
if [ -d "$workbench_path" ]; then
    # Install gcc-9
    sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
    sudo apt update
    sudo apt install gcc-9 -y
    sudo apt-get install build-essential -y

    # Verify installation
    gcc-9 --version

    # Run make in the tools folder of the Workbench
    cd $workbench_path/tools
    make CC=gcc-9 OS=LINUX
else
    echo "Workbench folder does not exist."
    exit 1
fi
