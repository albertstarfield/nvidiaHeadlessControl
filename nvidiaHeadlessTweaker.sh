#!/bin/bash
#sudo nvidia-xconfig --use-display-device=none
#allocate display ${AllocatedDisplayNumber} for all of the thing
AllocatedDisplayNumber=:69
offsetCoreClock=301 #GPU Core Clock in MHz
offsetMemoryClock=502 #Memory Offset Clock in MHz

#==================================================


















set -x
cd /etc/DeviceOptimization/NvidiaTweaks
rm /tmp/nvidiadedicatedcoolbitConfigInject.flag
if [ "$1" == 'test' ]; then
echo "Test mode"
else
sleep 4
fi
Xserversetup(){
nvidia-xconfig --query-gpu-info
nvidia-xconfig -a --allow-empty-initial-configuration --use-display-device=None --virtual=1280x720 --busid 1:0:0 --cool-bits=31 -o $(pwd)/tweakControlPanelCoolbitX.conf
}



sleep 0

nvidiaSettingsCLILoop(){
sleep 15
while true; do
nvidia-settings -c ${AllocatedDisplayNumber} -a '[gpu:0]/GPUGraphicsClockOffset[0]=301'
nvidia-settings -c ${AllocatedDisplayNumber} -a '[gpu:0]/GPUGraphicsClockOffset[1]=301'
nvidia-settings -c ${AllocatedDisplayNumber} -a '[gpu:0]/GPUGraphicsClockOffset[2]=301'
nvidia-settings -c ${AllocatedDisplayNumber} -a '[gpu:0]/GPUGraphicsClockOffset[3]=301'

nvidia-settings -c ${AllocatedDisplayNumber} -a '[gpu:0]/GPUMemoryTransferRateOffset[0]=501'
nvidia-settings -c ${AllocatedDisplayNumber} -a '[gpu:0]/GPUMemoryTransferRateOffset[1]=501'
nvidia-settings -c ${AllocatedDisplayNumber} -a '[gpu:0]/GPUMemoryTransferRateOffset[2]=501'
nvidia-settings -c ${AllocatedDisplayNumber} -a '[gpu:0]/GPUMemoryTransferRateOffset[3]=501'
sleep 3600
done
}

temporaryLaunchConfigBind(){
# since none any of the guide or manual book allows for custom configuration location file we are forced to use /etc/X11/xorg.conf on one computer thus theoretically only one configuration and one display device and no multiple device, however you could try to temporarily bind the $(pwd)/tweakControlPanelCoolbitX.conf --> /etc/X11/xorg.conf as a dummy config for the X server to launch then unbind so the main display server isn't erroring out due to wrong config
umount /etc/X11/xorg.conf
mount --bind $(pwd)/tweakControlPanelCoolbitX.conf /etc/X11/xorg.conf
while [ ! -f /tmp/nvidiadedicatedcoolbitConfigInject.flag ]; do
echo "waiting for the other thread to launch"
sleep 4
done
umount /etc/X11/xorg.conf
while [ -f /tmp/nvidiadedicatedcoolbitConfigInject.flag ]; do
echo "waiting for failure!"
sleep 5
done
umount -f /etc/X11/xorg.conf
echo "Rebinding!"
temporaryLaunchConfigBind
}

magiskLaunchSequence(){
temporaryLaunchConfigBind &
while true; do
touch /tmp/nvidiadedicatedcoolbitConfigInject.flag
#vncserver -ncache_cr -o $(pwd)/virtualCoolbitFramebuffer.log -ncache 10 -display ${AllocatedDisplayNumber} -autokill
#Xephyr :69
sleep 6
X ${AllocatedDisplayNumber} &
sleep 1
rm /tmp/nvidiadedicatedcoolbitConfigInject.flag
sleep 5
systemctl restart gdm
x11vnc -ncache_cr -o $(pwd)/virtualCoolbitFramebuffer.log -ncache 10 -display ${AllocatedDisplayNumber}
holdFunction
rm /tmp/nvidiadedicatedcoolbitConfigInject.flag
done
}

holdFunction(){
while true; do
sleep 5
done
}
#------ Main -------
Xserversetup
nvidiaSettingsCLILoop &
magiskLaunchSequence
