## kernel nethunter

nethunter kernel for alioth device support Android 11/12/13

## Description

some important file to build nethunter kernel in alioth device to run with latest Android version 11-13 and complied version working without needing any module

## Getting Started

### Dependencies

* need custom recovery (twrp)
  
### Installing

* backup stock kernel first
* flashing kernel.zip via twrp
* wipe cache & dalivk
* reboot system
* enjoy

## Notes:-

* Nethunter Kernel v2.0 | 4.19.278
* Release Date: 03/06/2023
* this kernel support Android 11/12/13 AOSP ROM only
* flash it and use directly without frimware drivers
* all needed patches and drivers are enabled then
* don't use module with this kernel Otherwise it will crash
* It is best to use the kernel only when it is needed 
* flash via TWRP (it's for hacking _ not for daily use)

## Changelog:-

* 
* Support all basic configuration by kali Nethunter 
* Ex:
* WIFI Monitor & Injection 
* wlan0 monitor (no Injection yet)
* RTL/Ath/Ralink drivers adapter 
* USB/VHCI/UART bluetooth device
* HID attack support
* SYSVIPC
* SDR
* Drivedroid app

## notes for dev only

* build scripts
    * This repository contains 3 bash script files to build kernel automatically but sure you downloaded needed tools like clang or Gcc 
    
* help files
    * (help.txt) this file contains some command to build kernel without bash script and some important stuff
    
* (install_needed.txt) this file very important to install needed tools to build kernel without errors in linux 

* based on F3-NoGravityKernel-1.3.0 source

## Authors
* dev. AhmadAllam
    * my account. [telegram](https://t.me/echo_Allam)
    * don't forget Palestine❤️