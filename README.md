## Planet Computers Cosmo communicator - Installation playbook

---

*/!\ This is still for advanced user. Use with caution.*
*/ ! \ v2 of the repo to support Linux V4*

## Introduction
Sick and tired of always have to reinstall the whole Linux side of my **Planet Computers Cosmo communicator** everytime I break it, which happened a few time already... And since I'm an SRE, automating the reinstallation process was obvious...

The idea is that you just need to reinstall the Gemian OS (V4), connect to your wifi and launch the playbook to have it set back to your liking. Runtime of the playbook is around 5 minutes on my tests. The same things by hand would take me at least an hour...

---

## Fastpass
### Boot up Linux
- Install Linux V4
- Log in using `cosmo` as password
- Connect to your wifi
- Retrieve your `ip address`
### Clone the repo
```
git clone https://github.com/m600x/cosmo-installer.git
cd cosmo-installer
```
### Change settings to your need
- Edit the file `inventories/host_vars/cosmo-communicator.yml`
  - See below for detailed instructions
### Launch the installation
```
./start.sh
ansible-playbook deploy.yml
```

---


## Description

### What it will do in short:
- Install bunch of somewhat useful crap (git, curl, htop, zsh, etc...)
- Remove `cosmo` user and add yours
- Change `root` password
- Add all your wifi network
- Set the keyboard layout, hostname and timezone
- Create a mounting point for the microSD card
- *Optional:* Add right click on long press
- *Optional:* Touchscreen as touchpad (relative positioning) [two finger right click]

## Settings
All settings are in the `inventories/host_vars/cosmo-communicator.yml` file

```
ansible_host:         <--- IP of your cosmo         (string)  eg: '192.168.0.42'
new_user_name:        <--- New username             (string)  eg: 'myuser'
new_user_password:    <--- New user pass            (string)  eg: 'mypassword'
new_root_password:    <--- New root pass            (string)  eg: 'myrootpassword'
new_hostname:         <--- New hostname             (string)  eg: 'cosmo'

cosmo:
  keyboard:           <--- Your cosmo kb layout     (string)  eg: 'gb'
  locale:             <--- Your locale              (string)  eg: 'en_US'
  timezone:           <--- Your timezone            (string)  eg: 'Europe/Paris'
  touchscreen:        <--- Relative position        (string)  eg: 'default', 'relative', 'absolute'
  rightclick:         <--- Rightclick on long press (boolean) eg: false

wifi_networks:
- ssid:               <--- SSID of your first wifi  (string)  eg: 'YouWifiNameA'
  psk:                <--- Passphrase               (string)  eg: 'mypassphrase'
- ssid:               <--- SSID of your first wifi  (string)  eg: 'YouWifiNameB'
  psk:                <--- Passphrase               (string)  eg: 'mypassphrase'
  protocole: wpa-psk  <--- (Optional) Security type (string)  eg: 'wpa-psk'
```