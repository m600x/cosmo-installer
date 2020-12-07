## Planet Computers Cosmo communicator - Installation playbook
---
*This is still for advanced user since it's not fully documented and bulletproof. Use with caution.*

## Description
Sick and tired of always have to reinstall the whole Linux side of my **Planet Computers Cosmo communicator** everytime I break it, which happened a few time already... Since I'm an SRE, automate the reinstallation process was obvious...

The idea is that you just need to reinstall the Gemian OS (V3 currently), connect to your wifi and launch the playbook to have it set back to your liking.

### What it will do in short:
- Install bunch of crap (git, curl, htop, zsh, etc...)
- Remove `cosmo` user and add yours
- Change `root` password
- Set the keyboard layout, hostname and timezone
- Create a mounting point for the microSD card
- Set back your SSH settings
- *Optional:* Add VNC server
- *Optional:* Add all your OpenVPN profile
- *Optional:* Add support for LTE connexion

## Required
- Linux V3 installed and Wifi connected, see: [Linux for Cosmo](https://support.planetcom.co.uk/index.php/Linux_for_Cosmo)
- The address IP of your Cosmo (`Taskbar wifi icon` > `your network` > `details`)
- Ansible installed on your machine

## Settings
All settings are in the `cosmo.yml` file

## Usage
- Edit your settings in `cosmo.yml`
- Launch the playbook with `ansible-playbook -i cosmo, cosmo.yml`

## Steps description
- Core (21 tasks)
  - Update installed packages
  - Install basic packages
  - Change hostname
  - Set timezone
  - Generate locale
  - Change root password
  - Add new user
  - Allow sudo passwprdless sudo
  - Allow new user to use NetworkManager settings
  - Delete default user cosmo
  - Fix keyboard layout
  - Create mount point for mSD to `/media/sdcard`
  - Symlink it to `~/sdcard`
  - Get mSD UUID and filesystem
  - Create entry in fstab for automount
- VNC (8 tasks) [*optional*]
  - Install VNC packages
  - Create password
  - Add autostart of the server
- SSH (4 tasks)
  - Add all SSH files contained in files/ssh
  - Fix rights for theses files
- Custom (2 tasks)
  - Install oh-my-zsh
  - Add custom .zshrc
- VPN (4 tasks) [*optional*]
  - Install OpenVPN
  - Add all VPN profile contained in files/vpn
  - Add vpn startup script
- Mobile data (6 tasks) [*optional*]
  - Install connman, cmst along with other for LTE support
  - Enable connman wifi connectivity
  - Enable roaming (*optional*)
  - Add carrier settings
  - Enable LTE
- Specific (3 tasks)
  - Download and install vault cli
