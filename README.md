# WACA: All Channel WiFi Analyzer

**Disclaimer**: *please, notice that a scientific paper describing WACA has been recently submitted. Therefore, we cannot provide much specifics until it gets published.*

### Author
* [Sergio Barrachina-Muñoz](https://github.com/sergiobarra)

### Project description

WACA is a platform built with [WARP v3 boards](http://warpproject.org) that simultaneously allows capturing all the WiFi's 20-MHz channels at the 2.4 or 5-GHz band. That is, any data sample measured at time `h` contains the RSSI detected in each of the WiFi channels: 14 (for the 2.4 GHz band) and 24 (for the 5 GHz band) allowed by the IEEE 802.11 channelization. From the bunch of benefits of WACA, we highlight: simplicity of experimental procedure (from deployment to post-processing), dedicated radio frequency (RF) chain per channel (easing hardware failure detection), and easiness of adaptation/configuration empowered by the [WARPLAb framework](https://warpproject.org/trac/wiki/WARPLab).

<img src="https://github.com/sergiobarra/WACA_WiFiAnalyzer/blob/master/resources/images/waca_design.PNG" alt="WACA design"
	title="WACA design" width="600" />

<img src="https://github.com/sergiobarra/WACA_WiFiAnalyzer/blob/master/resources/images/waca_deployment.PNG" alt="WACA deployment"
	title="WACA deployment" width="300" />

### Repository description
This repository contains the WARPLab (Matlab) code for taking RSSI measurements in a periodic basis.
* Main file: waca_main.m

### Contribute

If you want to contribute, please contact to [sergio.barrachina@upf.edu](sergio.barrachina@upf.edu)
