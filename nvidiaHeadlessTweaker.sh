#!/bin/bash
#sleep 9999
#exit
set -x
originPWD=$(pwd)
cd /etc/DeviceOptimization/NvidiaTweaks
if [ "${1}" == "testenv" ]; then
	cd ${originPWD}
fi
echo "Cleaning Legacy Flag"
rm /tmp/nvidiadedicatedcoolbitConfigInject.flag
#load as global initial parameter


##check configuration
configurationFile=$(pwd)/HardwareParameters.conf 
if [ ! -f ${configurationFile} ]; then
	echo "Missing configuration!"
	touch ${configurationFile}
fi
	. ${configurationFile}
	if [ -z "${AllocatedDisplayNumber}" ]; then
	echo "AllocatedDisplayNumber=:420" >> ${configurationFile}
fi
	if [ -z "${offsetCoreClock}" ]; then
	echo "offsetCoreClock=0" >> ${configurationFile}
fi
	if [ -z "${offsetMemoryClock}" ]; then
	echo "offsetMemoryClock=0" >> ${configurationFile}
fi
	if [ -z "${gpuNumber}" ]; then
	echo "gpuNumber=0" >> ${configurationFile}
fi
	if [ -z "${displayManager}" ]; then
	echo "displayManager=gdm" >> ${configurationFile}
fi
	if [ -z "${maximumGearState}" ]; then
	echo "maximumGearState=4" >> ${configurationFile}
fi
##-----

#==================================================




if [ "$1" == 'test' ]; then
	echo "Test mode"
	else
	sleep 4
fi
Xserversetup(){
lspci -vv
nvidia-smi
nvidia-xconfig --query-gpu-info
#rm $(pwd)/tweakControlPanelCoolbitX.conf*
if [ ! -f $(pwd)/tweakControlPanelCoolbitX.conf ]; then
	#nvidia-xconfig -a --probe-all-gpus --force-generate --allow-empty-initial-configuration --use-display-device=None --virtual=1280x720 --busid 1:0:0 --cool-bits=31 -o $(pwd)/tweakControlPanelCoolbitX.conf
	nvidia-xconfig -a --probe-all-gpus --force-generate --allow-empty-initial-configuration --use-display-device=None --virtual=1280x720 --cool-bits=31 -o $(pwd)/tweakControlPanelCoolbitX.conf
	# it doesn't have to render anything tho
fi
}



tailxorgLog(){
while true; do
	echo "Reading xorg Logs"
	uptime
	date
	#tail -f /var/log/xorg.${AllocatedDisplayNumber}
	tail -f $(pwd)/backgroundXorg.log
	sleep 1
done
}


nvidiaSettingsCLILoop(){
echo "Entering inotify..."
while inotifywait -e modify $(pwd)/HardwareParameters.conf; do
	echo "Hardware Parameter conf changed!"
	doChangeNvidiaSettings
done
}

doChangeNvidiaSettings(){
	. ${configurationFile} #reload every loop thus basically allows to be changed by just changing the HardwareParameters.conf without reboot
	for a in $(seq 1 ${maximumGearState});do
		nvidia-settings -c ${AllocatedDisplayNumber} -a [gpu:${gpuNumber}]/GPUGraphicsClockOffset[${a}]=${offsetCoreClock}
	done
	for a in $(seq 1 ${maximumGearState});do
		nvidia-settings -c ${AllocatedDisplayNumber} -a [gpu:${gpuNumber}]/GPUMemoryTransferRateOffset[${a}]=${offsetMemoryClock}
	done
}

backgroundXSequence(){
while true; do
	cat $(pwd)/tweakControlPanelCoolbitX.conf
	X -config $(pwd)/tweakControlPanelCoolbitX.conf -sharevts ${AllocatedDisplayNumber} -logfile $(pwd)/backgroundXorg.log &
	sleep 1
	#x11vnc -ncache_cr -o $(pwd)/virtualCoolbitFramebuffer.log -ncache 10 -display ${AllocatedDisplayNumber} > /dev/null 2
	holdFunction
	sleep 60
	echo "failure Detected"
done
}

holdFunction(){
while true; do
	sleep 600
done
}



#------ Main -------
Xserversetup
tailxorgLog &
doChangeNvidiaSettings
nvidiaSettingsCLILoop &
backgroundXSequence
