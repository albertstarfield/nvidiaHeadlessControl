# ✨ nvidiaHeadlessControl ✨
## Abstract
A daemon service that allows to control Nvidia adjust powermizer (Core and Memory) clocks or other settings headlessly without the need of using specific Xorg configured Server and without the need to use specific architecture such as Tesla, Quadro, GRID, GeForce Titan to do it. (Even if you are using Lenovo, Muxless, Optimus, and Wayland combined Setup which is where the utility was created and tested).

## Background
This daemon/utility creation was heavily inspired by my very Low-end handicapped by Lenovo Nvidia MX230 SKU's trying to play Genshin Impact or Sodium(salt) Paradise 60fps at 720p lowest setting at Linux. However it is not possible in the current condition due to the 256 cuda cores clock locked at 1.6-1.5GHz for the Core Clock which only stays around 30-50 fps most of the time, controlling in Windows is easy by just using ASUS GPU Tweak II or III however there is the annoyance that it will reset every 5 minutes and drop the the clock to ~137MHz thus requiring you to do readjustment every now, however in linux there the default setting of the GPU and the thermal target isn't as dismal as   


