Script om de vm aan te maken:

```bash
#!/bin/bash

# VM-configuratie

VM_NAME="Debian_PwnKit"
VDI_PATH="debian.vdi"

# VM aanmaken

VBoxManage createvm --name "$VM_NAME" --register
VBoxManage modifyvm "$VM_NAME" --memory 2048 --cpus 2 --nic1 nat
VBoxManage storagectl "$VM_NAME" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$VDI_PATH"
VBoxManage modifyvm "$VM_NAME" --boot1 disk --boot2 dvd --boot3 none --boot4 none
```
