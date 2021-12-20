# README

This repository was created to test and learn templating with [Packer](https://www.packer.io/).

I found https://www.hashicorp.com/blog/using-template-files-with-hashicorp-packer and built my files from there.
I am not fully sure if that example is 100% correct: in my opinion the defined "loop" doesn't correctly assign the variables to the function `templatefile`.

## usage

The files create VMs for VirtualBox and QEMU, both on the local machine.

Example calls:

```
# simply build all VMs
packer build  .

# do the same, but with more debug information
PACKER_LOG=1 PACKER_LOG_PATH=packer.log packer build  .

# build only some VM, overwrite the artifacts
PACKER_LOG=1 PACKER_LOG_PATH=packer.log packer build -force  -only=debian.virtualbox-iso.buster .
```

## templating the Debian preseed file

This is still a work in progress. Some variables are assigned correctly, some not. More research and learning needed.
Suggestions/PRs welcome ;-)
