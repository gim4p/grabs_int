# grabs_int
interpolating grab samples

#
Dependencies
1. Co-Kriging Code by R. C. Kitson
A modified version of the Co-Kriging implementation:
[GitHub Repo](https://github.com/rckitson/cokriging)

2. DACE Toolbox
Design and Analysis of Computer Experiments
    Version 2.5, September 4, 2002
    Developed by Hans Bruun Nielsen and IMM

3. IDW (Inverse Distance Weighting) Function
Developed by Andres Tovar for the course Design of Complex Mechanical Systems (ME 597) at Indiana University–Purdue University Indianapolis (Spring 2014).
Email: tovara@iupui.edu

#
Interpolation Methods:

Method 4: Full Grain Size Distribution
<br />
Each percentile of the grain size distribution is interpolated.
Enables reconstruction of the complete distribution for each location.

Method 5: Statistical Moments Approach
<br />
Interpolates key statistical moments like:
Median
Mean
Sorting
Skewness. Uses median and sorting to reconstruct unimodal grain size distributions.

#
Method 4 variograms for test grab sample file figge_stat_h.mat:
<img width="1357" alt="m4crossvar" src="https://github.com/user-attachments/assets/76a49e47-7314-4664-927e-2ce5bc0cbcfe" />

For the test data, theta should be approximately 5.

Method 4 for Interpolating Grain Size Classes in the Test Dataset:
<img width="1280" alt="m4inttest" src="https://github.com/user-attachments/assets/bd912ad1-c6cd-486a-98d0-6aed02b60288" />
