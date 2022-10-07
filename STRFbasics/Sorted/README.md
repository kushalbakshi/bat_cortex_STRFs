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
  + Please update `line 17` to reflect the naming convention of the `event.mat` file in the online dataset which is labeled as `SiteNumber_event.mat`

### Data Repository
+ The spike sorted neural event spike times are in a Google Drive found [here](!https://drive.google.com/drive/folders/1HXjWpwg7VeUWkwWCfUHzRkLRQ9Hj7Scd?usp=sharing)
  + The data are split into folders by animal ID
  + Each `.txt` file contains spike times, and corresponding `_event.mat` file contains timestamps that correspond to the onset of the DMR stimulus. The code is set up import this `_event.mat` on `line 17` but please update the path and name to reflect its storage on your local device
  + The `./Data` folder contains metadata files about the electrode insertion site like stereotaxic measurements which are used in `sorted_STRFs.m` to set the `depth_pos` and `RC_pos`
