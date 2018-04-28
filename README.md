# HX_App_iOS
iOS app for sizing CPU, memory, and storage requirements for CIsco Hyperflex hyperconvergence system

![alt text](https://github.com/jb80016/HX_App_iOS/blob/master/HX%20Screenshot%201.png)

![alt text](https://github.com/jb80016/HX_App_iOS/blob/master/HX%20Screenshot%202.png)

![alt text](https://github.com/jb80016/HX_App_iOS/blob/master/HX%20Screenshot%203.png)

Overview:

The purpose of this app is to provide the user with an easy way to determine the computing resources (cores and GHz), memory, and storage available to the VMs in a given Hyperflex (HX) configuration.  Simply use the pickers to choose processor type and memory per node and select the number of nodes in the cluster.  Both HX220c and HX240c hardware is supported.  For the H240c hardware, one can also select the number of drives per node via the slider from 6 to 23 hard disks.

All version 3 and version 4 processors supported are available for selection.  Memory sizes of 128, 256, 384, 512, and 768 are supported.  The resources consumed by the Controller VM (CVM) are taken into consideration for CPU core, CPU GHz, and memory for both HX220c and HX240c and subtracted from available resources to the VMs.  The storage metric used is the most conservative used by Cisco – 0.3333 TB usable per hard disk drive.  


Limitations:

Dedup and Compression are not supported yet.  

Performance information is not supported yet. 

VDI/VSI sizing is not supported at this time.

Compute-only nodes are not taken into consideration at this time.


Enhancements:

Other than addressing the limitations lists, I am open to suggested enhancements.

