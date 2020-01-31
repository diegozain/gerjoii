# Run gerjoii jobs with _slurm_

For usage just read 1. For the guts of it, read it all.

1. Outside ```gerjoii``` directory (in server) run either of: 

  ```sh go_kes_.sh``` wdc forward and inversion

  ```sh w_kes_.sh```  w   forward and inversion

  ```sh dc_kes_.sh``` dc  2d forward and inversion

  ```sh dc_kes__.sh``` dc  2.5d forward and inversion

2. These scripts activate the ```steady_``` routines in ```gerjoii/field/job-name/slurm/kestrel/```. Respectively from above:

  ```steady_.sh``` wdc forward and inversion

  ```steady_w_.sh```  w   forward and inversion

  ```steady_dc_.sh``` dc  2d forward and inversion

  ```steady_dc__.sh``` dc  2.5d forward and inversion

3. The above in turn make all new sub-job directories by copying the ```base``` directory in ```gerjoii/field/job-name/base```. They then set the _slurm_ parameters. Then they run the ```begin_``` and ```link_``` scripts. Respectively from above:

  ```begin_.bash & link_.bash``` wdc forward and inversion

  ```begin_w_.bash  & link_w_.bash```  w   forward and inversion

  ```begin_dc_.sh  & link_dc_.bash``` dc  2d forward and inversion

  ```begin_dc__.sh  & link_dc__.bash``` dc  2.5d forward and inversion

4. The above scripts are the ones that actually execute _slurm_ and then the _matlab_ main routines. Respectively from above:

  ```wdc_begin_.m & wdc_link_.m``` wdc forward and inversion

  ```w_begin_.m  & w_link_.m```  w   forward and inversion

  ```dc_begin_.m  & dc_link_.m``` dc  2d forward and inversion

  ```dc_begin__.m  & dc_link__.m``` dc  2.5d forward and inversion

  The ```begin_``` run the forward models and begin the inversion. The ```link_``` only keep the inversion going.

5. After the inversion is done, you can see the results on your local machine by running the  ```viewer_.sh``` routines in ```gerjoii/field/server-see/```. Doing this only downloads one _matlab_ .mat file at a time.

6. If you like what you see, you can bring all the inversion results from the server by going (in your local) to ```gerjoii/field/``` and running the ```download.sh``` routine.

