packer {
  required_version = "~> 1.7.8"

  # required_providers {
  #   qemu = {
  #     source  = "github.com/hashicorp/packer-plugin-qemu"
  #     version = "~> 1.0.1"
  #   }
  #   virtualbox = {
  #     source  = "github.com/hashicorp/packer-plugin-virtualbox"
  #     version = "~> 1.0.0"
  #   }
  # }
}

source "virtualbox-iso" "base-debian-amd64" {
  boot_wait                = "10s"
}
source "qemu" "base-debian-amd64" {
  boot_wait                = "10s"
}

# The "legacy_isotime" function has been provided for backwards compatability,
# but we recommend switching to the timestamp and formatdate functions.

locals {
  output_directory = "/mnt/platz/packer_output/build/${legacy_isotime("2006-01-02-15-04-05")}"
  iso_path_internal = "/mnt/platz/isos/debian"

  builds = {
    buster = {
        iso_checksum = "sha512:d82b0510fd919c2a851ee93ea0f7ad6779bfa597297a5c7463b63746799f001321ec4c9b8ba6cfe20248dd2da28100ad3b78e74489a8c0c573238f226a509a9d"
        iso_file = "debian-10.11.0-amd64-netinst.iso"
        iso_path_external = "https://cdimage.debian.org/cdimage/archive/10.11.0/amd64/iso-cd"
        vm_name = "base-buster"
      installs = ["nginx", "mariadb-server"]
    }
    /*bullseye_11.1 = {*/
        /*iso_checksum = "sha512:02257c3ec27e45d9f022c181a69b59da67e5c72871cdb4f9a69db323a1fad58093f2e69702d29aa98f5f65e920e0b970d816475a5a936e1f3bf33832257b7e92"*/
        /*iso_file = "debian-11.1.0-amd64-netinst.iso"*/
        /*iso_path_external = "http://cdimage.debian.org/cdimage/release/11.1.0/amd64/iso-cd"*/
        /*vm_name = "base-bullseye-11.1"*/
      /*installs = ["bullseye"]*/
    /*}*/
    bullseye = {
        iso_checksum = "sha512:c685b85cf9f248633ba3cd2b9f9e781fa03225587e0c332aef2063f6877a1f0622f56d44cf0690087b0ca36883147ecb5593e3da6f965968402cdbdf12f6dd74"
        iso_file = "debian-11.2.0-amd64-netinst.iso"
        iso_path_external = "http://cdimage.debian.org/cdimage/release/11.2.0/amd64/iso-cd"
        vm_name = "base-bullseye"
      installs = ["bullseye"]
    }
    bookworm = {
        iso_checksum = "sha512:e9a9581ce2f831e9ce0126c3a17d61b9f4c209369ebce8a3bae9062d6ce9a145497cf947bac1fdd8e22014c614b9d89f548e18945d212811a56ec4e3c4f17fcc"
        iso_file = "debian-testing-amd64-netinst.iso"
        iso_path_external = "http://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd"
        vm_name = "base-bookworm"
      installs = ["bookworm"]
    }
    stretch = {
        iso_checksum = "sha512:4a26730eade45c61f861df9aa872cb4a32099d98677d75437b44f044ebc967a9330e0f4fa60bf48b7daf7e5969b8e06e05fb480c1a7d7240e8ec7aed0d2c476d"
        iso_file = "debian-9.13.0-amd64-netinst.iso"
        iso_path_external = "https://cdimage.debian.org/cdimage/archive/9.13.0/amd64/iso-cd"
        vm_name = "base-stretch"
    installs = ["stretch"]
    }
}
}

build {
  name = "debian"
  description = <<EOF
This build creates images for :
* Debian
For the following builders :
* virtualbox-iso
It will create base images with:
* Stretch
* Buster
* Bullseye
* Bookworm
EOF

  dynamic "source" {
    for_each = local.builds

    labels   = ["source.virtualbox-iso.base-debian-amd64"]
    content {

    name             = source.key
    #vm_name          = source.key
    #output_directory = "/mnt/platz/packer_output/vbox/virtualbox_iso_debian_2021_amd64_${source.key}"
    output_directory = "${local.output_directory}_${source.key}"

  boot_command             = ["<esc><wait>", "install <wait>", " auto=true", " priority=critical", " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg <wait>", "<enter><wait>"]
  /*boot_wait                = "10s"*/
  chipset = "${var.chipset}"
  cpus = "${var.cpus}"
  disk_size         = "${var.disk_size}"
  format                = "ova"
  gfx_controller = "vmsvga"
  gfx_vram_size = "64"
  /*guest_additions_path     = "/home/vagrant/VBoxGuestAdditions.iso"*/
  guest_os_type            = "Debian_64"
  hard_drive_interface     = "sata"
  hard_drive_nonrotational = "true"
  /*http_content            = {*/
        /*"/preseed.cfg" = templatefile("${path.root}/http/preseed.pkrtpl.hcl",*/
             /*{ locale = var.locale, keyboard = var.keyboard, password = var.ssh_password,*/
             /*username = var.ssh_username, mirror = var.mirror, timezone = var.timezone,*/
             /*installs = source.value.installs, apt_cache_url = var.apt_cache_url } ) */
      /*}*/
  http_directory      = "http"
  iso_checksum        = "${source.value.iso_checksum}"
  iso_interface         = "sata"
  iso_target_extension = "iso"
  #iso_url           = "${var.iso_url}"
  iso_urls          = ["${local.iso_path_internal}/${source.value.iso_file}", "${source.value.iso_path_external}/${source.value.iso_file}"]
  keep_registered   = var.keep_registered
  memory            = "${var.memory}"
  nic_type          = "${var.nic_type}"
  sata_port_count   = "2"
  shutdown_command  = "echo '${var.ssh_password}' | sudo -S shutdown -P now"
  ssh_agent_auth    = var.ssh_agent_auth
  #ssh_pty           = var.ssh_pty
  ssh_username      = "${var.ssh_username}"
  ssh_password      = "${var.ssh_password}"
  ssh_timeout       = "${var.ssh_timeout}"
  vboxmanage        = [["modifyvm", "{{ .Name }}", "--rtcuseutc", "off"]]
  }
  }
  provisioner "ansible" {
    playbook_file = "ansible/vagrant-debian-11-guest-additions.yml"
    user          = "${var.ssh_username}"
  }

  provisioner "ansible" {
    playbook_file = "ansible/prepare_debops.yml"
    user          = "${var.ssh_username}"
  }
}
build {
  name = "debian"
  description = <<EOF
This build creates images for :
* Debian
For the following builders :
* virtualbox-iso
It will create base images with:
* Stretch
* Buster
* Bullseye
* Bookworm
EOF

  dynamic "source" {
    for_each = local.builds

    labels   = ["source.qemu.base-debian-amd64"]
    content {

    name             = source.key
    vm_name          = source.key
    #output_directory = "/mnt/platz/packer_output/qemu/qemu_iso_debian_2021_amd64_${source.key}"
    output_directory = "${local.output_directory}_${source.key}"

  boot_command             = ["<esc><wait>", "install <wait>", " auto=true", " priority=critical", " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg <wait>", "<enter><wait>"]
  /*boot_wait                = "10s"*/
  cpus = "${var.cpus}"
  disk_size         = "${var.disk_size}"
  format                = "qcow2"
  /*http_content            = {*/
        /*"/preseed.cfg" = templatefile("${path.root}/http/preseed.pkrtpl.hcl",*/
             /*{ locale = var.locale, keyboard = var.keyboard, password = var.ssh_password,*/
             /*username = var.ssh_username, mirror = var.mirror, apt_cache_url = var.apt_cache_url } )*/
      /*}*/
  http_directory      = "http"
  iso_checksum        = "${source.value.iso_checksum}"
  iso_target_extension = "iso"
  #iso_url           = "${var.iso_url}"
  iso_urls          = ["${local.iso_path_internal}/${source.value.iso_file}", "${source.value.iso_path_external}/${source.value.iso_file}"]
  memory            = "${var.memory}"
  shutdown_command  = "echo '${var.ssh_password}' | sudo -S shutdown -P now"
  ssh_agent_auth    = var.ssh_agent_auth
  #ssh_pty           = var.ssh_pty
  ssh_username      = "${var.ssh_username}"
  ssh_password      = "${var.ssh_password}"
  ssh_timeout       = "${var.ssh_timeout}"
  }
  }

  provisioner "ansible" {
    playbook_file = "ansible/prepare_debops.yml"
    user          = "${var.ssh_username}"
  }
}
