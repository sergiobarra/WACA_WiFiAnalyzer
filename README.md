# WACA: Wi-Fi All-Channel Analyzer

**Scientific papers using WACA**: 
- Barrachina-Muñoz, S., & Knightly, E. W. (2021). Wi-Fi Channel Bonding: An All-Channel System and Experimental Study From Urban Hotspots to a Sold-Out Stadium. IEEE/ACM Transactions on Networking. [Paper](https://ieeexplore.ieee.org/document/9431669).
- Barrachina-Muñoz, S., Bellalta, B., & Knightly, E. (2020, September). Wi-Fi All-Channel Analyzer. In Proceedings of the 14th International Workshop on Wireless Network Testbeds, Experimental evaluation & Characterization (pp. 72-79). [Slides](https://github.com/sergiobarra/WACA_WiFiAnalyzer/blob/master/resources/slides/barrachina_waca_wintech2020.pdf) and [video](https://www.youtube.com/watch?v=QxOGX7h-YRc&t=0s) of the presentation.


### Author
* [Sergio Barrachina-Muñoz](https://github.com/sergiobarra)

### Project description

WACA is a platform built with [WARP v3 boards](http://warpproject.org) that simultaneously allows capturing all the WiFi's 20-MHz channels at the 2.4 or 5-GHz band. That is, any data sample measured at time `t` contains the RSSI detected in each of the WiFi channels: 14 (for the 2.4 GHz band) and 24 (for the 5 GHz band) allowed by the IEEE 802.11 channelization. From the bunch of benefits of WACA, we highlight: simplicity of experimental procedure (from deployment to post-processing), dedicated radio frequency (RF) chain per channel (easing hardware failure detection), and easiness of adaptation/configuration empowered by the [WARPLAb framework](https://warpproject.org/trac/wiki/WARPLab).

<img src="https://github.com/sergiobarra/WACA_WiFiAnalyzer/blob/master/resources/images/waca_design.PNG" alt="WACA design"
	title="WACA design" width="600" />

<img src="https://github.com/sergiobarra/WACA_WiFiAnalyzer/blob/master/resources/images/waca_deployment.png" alt="WACA deployment"
	title="WACA deployment" width="300" />

### Repository description
This repository contains the WARPLab (Matlab) code for taking RSSI measurements in a periodic basis.
* Main file: waca_main.m

### Dataset v1 (2019)
The dataset presented in "Sergio Barrachina-Muñoz, Boris Bellalta, and Edward Knightly. 2020. Wi-Fi All-Channel Analyzer. WinTech (2020)". *Another in-depth analysis of the datasets is going to be published in short.*
- [Complete dataset](https://zenodo.org/record/3952557) (multiple .zip files).
- [Camp Nou stadium dataset](https://zenodo.org/record/3960029) (single .zip file). 

### Contribute

If you want to contribute, please contact to [sergio.barrachina@upf.edu](sergio.barrachina@upf.edu)
