# Generate STRFs from spike-sorted data

### Getting started
+ Download all the files in this directory.
+ Open `sorted_STRFs.m` and update all the file paths to your local machine

### Navigating this directory

+ The main MATLAB script that imports data, calls nested functions, and vizualizes/saves the data is `sorted_STRFs.m`
  + The variable `strf_info` within this file reads in the excel sheet with valid STRFs
  + The variable `bats` can either find all the unique entries from the excel find or can be set manually
  + The variable `spike_path` is your local absolute path to the folder containing the animal spike time directories
  + The `depth_pos` and `RC_pos` set the stereotaxic location of each electrode  
