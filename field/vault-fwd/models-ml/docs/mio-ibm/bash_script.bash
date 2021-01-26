#!/bin/bash
echo "Working directory in singularity: "
pwd
cat /etc/os-release
python -c "import sys ;print(sys.version)"
python fully_connected_feed.py --input_data_dir=./tmp --log_dir=./tmp   > sing_out.$JOB 2>sing_err.$JOB


