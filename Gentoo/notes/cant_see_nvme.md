lspci -i | grep -i vmd

if you see this you need VMD built in NOT as module
otherwise disks wont be detected (NVME)

device drivers -> pci -> pci controllers -> intel volume management device
