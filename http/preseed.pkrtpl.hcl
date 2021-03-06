# https://www.debian.org/releases/bullseye/example-preseed.txt

### Localization
d-i debian-installer/locale string ${locale}
d-i keyboard-configuration/xkb-keymap select ${keyboard}

### Network configuration
#d-i netcfg/enable boolean true
d-i netcfg/choose_interface select auto
d-i netcfg/dhcp_timeout string 60

# Disable that annoying WEP key dialog.
d-i netcfg/wireless_wep string

### Mirror settings
d-i mirror/country string manual
d-i mirror/http/hostname string ${mirror}
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string ${apt_cache_url}
#d-i mirror/http/proxy string

### Account setup
# Skip creation of a root account (normal user account will be able to use sudo).
d-i passwd/root-login boolean false

# create the vagrant account, password = vagrant as per https://www.vagrantup.com/docs/boxes/base
d-i passwd/user-fullname string ${username}
d-i passwd/user-uid string 1000
d-i passwd/username string ${username}
d-i passwd/user-password password ${password}
d-i passwd/user-password-again password ${password}
d-i user-setup/allow-password-weak boolean true
d-i user-setup/encrypt-home boolean false

### Clock and time zone setup
d-i clock-setup/utc boolean true
d-i time/zone string ${timezone}
d-i clock-setup/ntp boolean false

### Partitioning
d-i partman-auto/method string lvm
d-i partman-auto-lvm/guided_size string max
d-i partman-auto/choose_recipe select home
d-i partman-lvm/device_remove_lvm boolean true
d-i partman-lvm/confirm_nooverwrite boolean true
d-i partman-lvm/confirm boolean true
d-i partman-md/confirm boolean true
d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

### Package selection
d-i base-installer/install-recommends boolean false
tasksel tasksel/first multiselect standard, ssh-server

#d-i pkgsel/include string build-essential dkms linux-headers-amd64

d-i pkgsel/include %{ for install in installs ~}${install} %{ endfor }string
 openssh-server cryptsetup build-essential libssl-dev libreadline-dev zlib1g-dev
 linux-source dkms nfs-common linux-headers-$(uname -r) perl cifs-utils
 software-properties-common rsync ifupdown

d-i pkgsel/install-language-support boolean false
popularity-contest popularity-contest/participate boolean false
d-i apt-setup/services-select multiselect security, updates

### Boot loader installation
d-i grub-installer/only_debian boolean true
#d-i grub-installer/bootdev string /dev/vda

# Aufgrund von m??glicherweise vorhandenen USB-Sticks kann der Speicherort
# des prim??ren Laufwerks grunds??tzlich nicht sicher erkannt werden, daher
# muss er angegeben werden:
#d-i grub-installer/bootdev  string /dev/sda
# Um auf das prim??re Laufwerk zu installieren (angenommen, dies ist kein
# USB-Stick):
d-i grub-installer/bootdev  string default

# Wenn Sie alternativ an einen anderen Ort als in die UEFI-Partition/den
# Boot Record installieren m??chten, entfernen Sie hier die Kommentarzeichen
# und passen Sie die Zeilen an:
#d-i grub-installer/only_debian boolean false
#d-i grub-installer/with_other_os boolean false
#d-i grub-installer/bootdev  string (hd0,1)
# Um grub auf mehrere Ger??te zu installieren:
#d-i grub-installer/bootdev  string (hd0,1) (hd1,1) (hd2,1)

### Finishing up the installation
d-i finish-install/keep-consoles boolean true
d-i finish-install/reboot_in_progress note

## Specific commands related to Vagrant:
# - Setup sudo.
# - Setup public key for Vagrant user.
#   Public key source is https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
# - SSH security: disable root login.
# - SSH security: disable password authentication. Disallows login via the GUI!
# - Don't affect network interface to mac address.
# - Cleanup to save disk space.
d-i preseed/late_command string \
    in-target sed -i 's/^%sudo.*$/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g' /etc/sudoers; \
    in-target /bin/sh -c "echo 'Defaults env_keep += \"SSH_AUTH_SOCK\"' >> /etc/sudoers"; \
    in-target mkdir -p /home/${username}/.ssh; \
    in-target /bin/sh -c "echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHnascY26NkLCYOgr+niPXUw3DATiMFm6Z0FJ53cBkIC sgw-ed25519-key-2018' >> /home/${username}/.ssh/authorized_keys"; \
    in-target chown -R ${username}:${username} /home/${username}/; \
    in-target chmod -R go-rwx /home/${username}/.ssh/authorized_keys; \
    in-target sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config; \
    in-target sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config; \
    in-target rm /etc/udev/rules.d/70-persistent-net.rules; \
    in-target aptitude clean; \
    in-target dd if=/dev/zero of=/EMPTY bs=1M; \
    in-target rm -f /EMPTY;
