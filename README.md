# ✨ nvidiaHeadlessControl ✨
## Abstract or Description
A daemon service that allows to control Nvidia adjust powermizer (Core and Memory) clocks or other settings headlessly without the need of using specific Xorg configured Server and without the need to use specific architecture such as Tesla, Quadro, GRID, GeForce Titan to do it. (Even if you are using Lenovo, Muxless, Optimus, and Wayland combined Setup which is where the utility was created and tested).

## Background
This daemon/utility creation was heavily inspired by my very Low-end handicapped by Lenovo Nvidia MX230 SKU's trying to play Overwatch 2 60fps at 720p lowest setting on Linux Platform. However it is not possible in the current condition due to the 256 cuda cores clock locked at 1.6-1.5GHz for the Core Clock which only stays around 30-50 fps most of the time, controlling hardware parameters in Windows platform is very easy by just using 3rd party product such as ASUS GPU Tweak, MSI Afterburner, etc. however there is the annoyance that it will reset every 5 minutes and drop the the clock to ~137MHz thus requiring you to do readjustment every now and then. It is still a pretty minor annoyance in the Windows platform compare to GNU/Linux platform. In linux the clock or hardware adjustment capabilities are completely locked down by Nvidia proprietary driver if your GPU isn't from the Tesla, Quadro, GRID, or GeForce Titan family. Even if Nvidia locked down at the surface about the hardware control the community found out that Nvidia still opens out the control if the user set a certain parameter on the display or xorg.conf which is "Coolbits". 

"Coolbits" is a parameter which controls the driver to allows certain hardware features control to be displayed or unlocked within the official control panel or to be controllable through utility. Coolbits on Windows can be easily set through registry and not impact too much of the user experience throughout the system/platform, however in GNU/Linux platform you are forced to use Xorg display system to be able to set coolbits and even then if you successfully configured the coolbits you have to be in/using the display to set the clock even if you set through nvidia-settings cli utility, or you want to run some specific wayland only app or you want to use the wayland gestures to be mac-like 1:1 gestures experience, or you have a muxless or optimus laptop there are various of issues like at Xorg doesn't use iGPU (for instance it was Intel UHD620) to render its UI and fallsback to llvmpipe or even worse the display manager fails to load. And that's why this utility is developed.

This utility allows to control the hardware parameters (which allows you to overclock, or in theory adjust fan and other parameter) by mocking and spawning nvidia desired coolbits X11 server and /etc/X11/xorg.conf (mounting/binding temporarily it just like magisk like in Android) in the background/headlessly while allowing the display to display the user desired windowing system such as Wayland or etc.  

## Installation
0. Install inotify-tools & the proprietary Nvidia Driver (was tested in Nvidia version 470 & 515), and clone this repo
 
  	Example for ubuntu
  
		sudo apt install inotify-tools
		git clone https://github.com/albertstarfield/nvidiaHeadlessControl
1. create directory

		sudo mkdir /etc/DeviceOptimization/NvidiaTweaks
2. copy script to directory

		sudo cp nvidiaHeadlessControl/* /etc/DeviceOptimization/NvidiaTweaks
3. enable the service

		sudo systemctl enable /etc/DeviceOptimization/NvidiaTweaks/nvidiaHeadlessTweaker.service
4. open up the HardwareParameters.conf and adjust offsetCoreClock and offsetMemoryClock parameter (you can do this after booting up and every changes will be applied immediately)
5. reboot (Note : Your display manager may restart after it boot up, it is normal it will come back to life normal)

Side note : the config file will auto regenerate each boot, so you don't need to fiddle around with the configuration file



## Special Thanks
### Special thanks to these inspiring forums that makes this project or control possible (Sarcasm)
1. https://www.reddit.com/r/archlinux/comments/l72f37/nvidia_is_it_possible_to_overclock_on_wayland/
2. https://forums.developer.nvidia.com/t/setting-coolbits-on-wayland/174700
3. https://www.phoronix.com/forums/forum/linux-graphics-x-org-drivers/wayland-display-server/1285932-xwayland-21-1-3-nears-with-support-for-nvidia-495-driver-s-gbm

### Okay for real this time, these are the helpful one
1. https://forums.developer.nvidia.com/t/solved-coolbits-without-xorg-conf/37305/5
2. https://www.phoronix.com/review/197/2
3. https://wiki.archlinux.org/title/NVIDIA/Tips_and_tricks
4. https://unix.stackexchange.com/questions/559918/how-to-add-virtual-monitor-with-nvidia-proprietary-driver
5. https://github.com/NVIDIA/nvidia-settings/issues/65#issuecomment-840205288


> I love challenges <3 that why i'm able to overclock nvidia gpu even by using wayland, ehe~ 

There is alternative which i just found
1. https://forums.developer.nvidia.com/t/option-coolbits-is-not-used-optimus-enabled-laptop-running-an-rtx-2070-manjaro-linux/111771/14 made by 
hexengraf.
_Hexengraf has almost the same approach but instead of keeping the X server alive in the background, Hexengraf stop the X server that controls the "Hardware Adjustments or Clocks" then respawn to the desired display manager_


