variable "apt_cache_url" {
  type    = string
  default = "http://ivy.loc.oops.co.at:3142"
}

variable "boot_wait" {
  type    = string
  default = "10s"
}

variable "bundle_iso" {
  type    = string
  default = "false"
}

variable "chipset" {
  type    = string
  default = "ich9"
}

variable "communicator" {
  type    = string
  default = "ssh"
}

variable "country" {
  type    = string
  default = "CA"
}

variable "cpus" {
  type    = string
  default = "1"
}

variable "description" {
  type    = string
  default = "Base box for x86_64 Debian Bullseye 11.x"
}

variable "disk_size" {
  type    = string
  default = "7500"
}

variable "domain" {
  type    = string
  default = ""
}

variable "guest_os_type" {
  type    = string
  default = "Debian_64"
}

variable "headless" {
  type    = string
  default = "false"
}

variable "host_port_max" {
  type    = string
  default = "4444"
}

variable "host_port_min" {
  type    = string
  default = "2222"
}

variable "http_directory" {
  type    = string
  default = "."
}

variable "http_port_max" {
  type    = string
  default = "9000"
}

variable "http_port_min" {
  type    = string
  default = "8000"
}

variable "iso_checksum" {
  type    = string
  default = "sha512:02257c3ec27e45d9f022c181a69b59da67e5c72871cdb4f9a69db323a1fad58093f2e69702d29aa98f5f65e920e0b970d816475a5a936e1f3bf33832257b7e92"
  # default = "file:http://cdimage.debian.org/cdimage/release/current/amd64/iso-cd/SHA512SUMS"
}

variable "iso_file" {
  type    = string
  default = "debian-11.1.0-amd64-netinst.iso"
}

variable "iso_path_external" {
  type    = string
  default = "http://cdimage.debian.org/cdimage/release/current/amd64/iso-cd"
}

variable "iso_path_internal" {
  type    = string
  default = "/mnt/platz/isos/debian"
}

variable "keep_registered" {
  type    = string
  default = "false"
}

variable "keyboard" {
  type    = string
  default = "us"
}

variable "language" {
  type    = string
  default = "en"
}

variable "locale" {
  type    = string
  default = "en_CA.UTF-8"
}

variable "memory" {
  type    = string
  default = "1024"
}

variable "min_vagrant_version" {
  type    = string
  default = "2.2.19"
}

variable "mirror" {
  type    = string
  default = "ftp2.de.debian.org"
}

variable "nic_type" {
  type    = string
  default = ""
}

variable "packer_cache_dir" {
  type    = string
  default = "${env("PACKER_CACHE_DIR")}"
}

variable "preseed_file" {
  type    = string
  #default = "template/debian/11_bullseye/base.preseed"
  default = "base.preseed"
}

variable "qemu_binary" {
  type    = string
  default = "qemu-system-x86_64"
}

variable "shutdown_timeout" {
  type    = string
  default = "5m"
}

variable "skip_export" {
  type    = string
  default = "false"
}

variable "ssh_agent_auth" {
  type    = string
  default = "true"
}

variable "ssh_clear_authorized_keys" {
  type    = string
  default = "false"
}

variable "ssh_disable_agent_forwarding" {
  type    = string
  default = "false"
}

variable "ssh_file_transfer_method" {
  type    = string
  default = "scp"
}

variable "ssh_fullname" {
  type    = string
  default = "Ghost Writer"
}

variable "ssh_handshake_attempts" {
  type    = string
  default = "10"
}

variable "ssh_keep_alive_interval" {
  type    = string
  default = "5s"
}

variable "ssh_password" {
  type    = string
  default = "1ma63b0rk3d"
}

variable "ssh_port" {
  type    = string
  default = "22"
}

variable "ssh_pty" {
  type    = string
  default = "false"
}

variable "ssh_timeout" {
  type    = string
  default = "60m"
}

variable "ssh_username" {
  type    = string
  default = "ghost"
}

variable "start_retry_timeout" {
  type    = string
  default = "5m"
}

variable "system_clock_in_utc" {
  type    = string
  default = "true"
}

variable "timezone" {
  type    = string
  default = "UTC"
}

variable "vagrantfile_template" {
  type    = string
  default = "template/debian/11_bullseye/vagrant.rb.j2"
}

variable "version" {
  type    = string
  default = "0.0.0"
}

variable "vm_name" {
  type    = string
  default = "base-bullseye"
}

variable "vnc_vrdp_bind_address" {
  type    = string
  default = "127.0.0.1"
}

variable "vnc_vrdp_port_max" {
  type    = string
  default = "6000"
}

variable "vnc_vrdp_port_min" {
  type    = string
  default = "5900"
}
