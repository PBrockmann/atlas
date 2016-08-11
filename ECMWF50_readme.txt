
====================================================
Recuperation of ECMWF levels:
http://www.ecmwf.int/products/data/technical/model_levels/model_def_50.html
====================================================
vi ECMWF50_stdpressurelevels.cdl 
awk '{printf "%f, ", $4}' ECMWF50_orig.txt 
awk '{printf "%f, ", $5}' ECMWF50_orig.txt
