this is a minimal working example for trouble shooting.

go to slurm/ and run

sbatch begin_disk_.bash

matlab output will be in: JOB-ID-NUMBER.out

The number of cores used by matlab is 10 (for a node with 256Gb of memory). 
This number is chosen to not run out of memory at the most memory intensive point in the code.

This can be modified in:

tmp/workers.txt

This particular example will take about 9 hours to finish with 1 node and 10 cores.
