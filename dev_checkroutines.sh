set -x
while [ -z "$(cat /etc/X11/xorg.conf | grep nvidia)" ] || [ -z "$(cat /etc/X11/xorg.conf | grep Virtual)" ] ||  [ -z "$(cat /etc/X11/xorg.conf | grep Coolbits | grep 31)" ] ; do
echo "Waiting to get correct configuration mounted!"
sleep 0.3
done
