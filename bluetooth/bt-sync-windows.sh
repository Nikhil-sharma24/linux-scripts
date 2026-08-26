echo "
cd ControlSet001
cd Services
cd BTHPORT
cd Parameters
cd Keys
cd 0045e2d93912
ls
" | wl-copy
echo "paste"
cd /run/media/nikhil/Windows-SSD/Windows/System32/config
sudo chntpw -e SYSTEM
