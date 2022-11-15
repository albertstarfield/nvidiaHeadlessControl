#!/bin/bash
#sleep 9999
#exit
set -x
cd /etc/DeviceOptimization/NvidiaTweaks
rm /tmp/nvidiadedicatedcoolbitConfigInject.flag
#load as global initial parameter
. $(pwd)/HardwareParameters.conf 
#==================================================



















if [ "$1" == 'test' ]; then
echo "Test mode"
else
sleep 4
fi
Xserversetup(){
nvidia-xconfig --query-gpu-info
#rm $(pwd)/tweakControlPanelCoolbitX.conf*
if [ ! -f $(pwd)/tweakControlPanelCoolbitX.conf ]; then
nvidia-xconfig -a --probe-all-gpus --force-generate --allow-empty-initial-configuration --use-display-device=None --virtual=1280x720 --busid 1:0:0 --cool-bits=31 -o $(pwd)/tweakControlPanelCoolbitX.conf
fi
}



sleep 0

nvidiaSettingsCLILoop(){
sleep 15
while true; do
. $(pwd)/HardwareParameters.conf  #reload every loop thus basically allows to be changed by just changing the HardwareParameters.conf without reboot
nvidia-settings -c ${AllocatedDisplayNumber} -a [gpu:0]/GPUGraphicsClockOffset[0]=${offsetCoreClock}
nvidia-settings -c ${AllocatedDisplayNumber} -a [gpu:0]/GPUGraphicsClockOffset[1]=${offsetCoreClock}
nvidia-settings -c ${AllocatedDisplayNumber} -a [gpu:0]/GPUGraphicsClockOffset[2]=${offsetCoreClock}
nvidia-settings -c ${AllocatedDisplayNumber} -a [gpu:0]/GPUGraphicsClockOffset[3]=${offsetCoreClock}

nvidia-settings -c ${AllocatedDisplayNumber} -a [gpu:0]/GPUMemoryTransferRateOffset[0]=${offsetMemoryClock}
nvidia-settings -c ${AllocatedDisplayNumber} -a [gpu:0]/GPUMemoryTransferRateOffset[1]=${offsetMemoryClock}
nvidia-settings -c ${AllocatedDisplayNumber} -a [gpu:0]/GPUMemoryTransferRateOffset[2]=${offsetMemoryClock}
nvidia-settings -c ${AllocatedDisplayNumber} -a [gpu:0]/GPUMemoryTransferRateOffset[3]=${offsetMemoryClock}
sleep 60
done
}

magiskLaunchSequence(){
while true; do
cat $(pwd)/tweakControlPanelCoolbitX.conf
X -config $(pwd)/tweakControlPanelCoolbitX.conf -sharevts ${AllocatedDisplayNumber} &
sleep 1
x11vnc -ncache_cr -o $(pwd)/virtualCoolbitFramebuffer.log -ncache 10 -display ${AllocatedDisplayNumber}
holdFunction
sleep 60
echo "failure Detected"
done
}

holdFunction(){
while true; do
echo "Should be launched"
sleep 5
done
}
#------ Main -------
Xserversetup
nvidiaSettingsCLILoop &
magiskLaunchSequence
