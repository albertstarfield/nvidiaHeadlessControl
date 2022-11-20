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

if [ -z "$(which inotifywait)" ]; then
    echo "inotifywait not installed."
    echo "In most distros, it is available in the inotify-tools package."
    exit 1
fi


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
	nvidia-xconfig -a --probe-all-gpus --force-generate --allow-empty-initial-configuration --use-display-device=None --virtual=1280x720 --cool-bits=31 -o $(pwd)/tweakControlPanelCoolbitX.conf
	# it doesn't have to render anything tho
fi
}

function nvidiaSettingsCLILoop(){
echo "Entering inotify..."
inotifywait --recursive --monitor --event modify $(pwd)/HardwareParameters.conf | while read changed; do
	echo "Hardware Parameter conf changed!"
	doChangeNvidiaSettings
	backgroundXSequence
done
}

function doChangeNvidiaSettings(){
	. ${configurationFile} #reload every loop thus basically allows to be changed by just changing the HardwareParameters.conf without reboot
	for a in $(seq 1 ${maximumGearState});do
		nvidia-settings -c ${AllocatedDisplayNumber} -a [gpu:${gpuNumber}]/GPUGraphicsClockOffset[${a}]=${offsetCoreClock}
	done
	for a in $(seq 1 ${maximumGearState});do
		nvidia-settings -c ${AllocatedDisplayNumber} -a [gpu:${gpuNumber}]/GPUMemoryTransferRateOffset[${a}]=${offsetMemoryClock}
	done
}

function backgroundXSequence(){
cat $(pwd)/tweakControlPanelCoolbitX.conf
X -config $(pwd)/tweakControlPanelCoolbitX.conf -sharevts ${AllocatedDisplayNumber} -logfile $(pwd)/backgroundXorg.log &
sleep 1
echo "failure Detected"
}


#------ Main -------
Xserversetup
backgroundXSequence &
doChangeNvidiaSettings
nvidiaSettingsCLILoop
