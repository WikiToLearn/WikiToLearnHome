# Setup with virtual machine

## Install virtual machine hypervisor

The first step is install your prefered [virtual machine hypervisor](https://en.wikipedia.org/wiki/Hypervisor).

check if your cpu and motherboard supports virtualization extensions like VT-x/AMD-v.

[VirtualBox](https://www.virtualbox.org/) is the easiest tool for this particular setup.

## Install guest OS

Now you have to install your guest OS.

This setup requires Docker x64 version on Linux.

[Here](https://docs.docker.com/engine/installation/linux/) a list of distros.

## Network stuff

WikiToLearn has a complex layout because is a multi-domain website, this is why we have the `local.wikitolearn-test.org` domain.

This domain si pointed to 127.0.0.1 (the local pc), if you have the WikiToLearn system running on a VM is like to have the system running on another PC.

A possible workaround is to install a proxy in the VM, for example squid, and point your browser to surf the net via this proxy.

Another solution, with virtualbox, is to use the NAT to forward port 80 and 443 from your pc to the VM, this can be difficult in OSX because you need root access in order to bind ports lower than 1024.

Another solution is to use ssh port tunneling, so you can spin up your VM, ssh into the guest os and use all ssh magic stuff to forward the traffic to the VM.

Another possible solution is to use the `hosts` file to bind all `local.wikitolearn-test.org` sub-domains to the VM.

Those domains can be changed quite frequently and this is why we don't endorse this solution
