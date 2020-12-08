## Planet Computers Cosmo communicator - Installation playbook
---
*/!\ This is still for advanced user. Use with caution.*

## Description
Sick and tired of always have to reinstall the whole Linux side of my **Planet Computers Cosmo communicator** everytime I break it, which happened a few time already... Since I'm an SRE, automate the reinstallation process was obvious...

The idea is that you just need to reinstall the Gemian OS (V3 currently), connect to your wifi and launch the playbook to have it set back to your liking.

### What it will do in short:
- Install bunch of crap (git, curl, htop, zsh, etc...)
- Remove `cosmo` user and add yours
- Change `root` password
- Set the keyboard layout, hostname and timezone
- Create a mounting point for the microSD card
- Readd keyboard hotkey (LCD brightness, mute, split screen...)
- Add keyboard backlight control
- *Optional:* Add right click on long press [using stock driver]
- *Optional:* Touchscreen as touchpad (relative positioning) [using mtrack driver which support right click]
- *Optional:* Set back your SSH settings
- *Optional:* Add VNC server
- *Optional:* Add all your OpenVPN profile
- *Optional:* Add support for LTE connexion
- *Optional:* Specific task where you add whatever you might need

### Notes
The keyboard hotkey (typically Fn+Something) does not use the stock meta key `Fn` but `Alt`. So to increase the LCD brightness you would use `Alt+N` instead of `Fn+N`.

List of currently supported hotkey:
- LCD brightness up: `Alt + N`
- LCD brightness down: `Alt + B`
- Keyboard backlight up: `Alt + Shift + N`
- Keyboard backlight down: `Alt + Shift + B`
- Mute mic: `Alt + T`
- Mute: `Alt + Y`
- Move window to left: `Ctrl + Shift + Left`
- Move window to right: `Ctrl + Shift + Right`
- Maximize window: `Ctrl + Shift + Up`
- Minimize window: `Ctrl + Shift + Down`

---

## Required
- Linux V3 installed and Wifi connected, see: [Linux for Cosmo](https://support.planetcom.co.uk/index.php/Linux_for_Cosmo)
- The address IP of your Cosmo (`Taskbar wifi icon` > `your network` > `details`)
- Docker installed see: [Get docker](https://docs.docker.com/get-docker/)

---

## Settings
All settings are in the `cosmo.yml` file

```
ansible_host:               <--- IP of your cosmo         (string)  eg: '127.0.0.1'
new_hostname:               <--- New hostname             (string)  eg: 'cosmo'
new_user_name:              <--- New username             (string)  eg: 'myuser'
new_user_pass:              <--- New user pass            (string)  eg: 'mypassword'
new_root_password:          <--- New root pass            (string)  eg: 'myrootpassword'
cosmo_keyboard_layout:      <--- Your cosmo layout        (string)  eg: 'gb'
locale:                     <--- Your locale              (string)  eg: 'en_US'
tz:                         <--- Your timezone            (string)  eg: 'Europe/Paris'
touch_relative:             <--- Relative position        (boolean) eg: true
touch_rightclick:           <--- Rightclick on long press (boolean) eg: false
ssh_support:                <--- If SSH file must be sent (boolean) eg: false
mobile_data_support:        <-- Install upport for LTE    (boolean) eg: true
mobile_data_roaming:        <--- Allow roaming            (boolean) eg: false
mobile_data_settings:
  AccessPointName:          <--- Carrier APN              (string)  eg: 'orange.fr'
  Username:                 <--- Carrier Username         (string)  eg: 'orange'
  Password:                 <--- Carrier password         (string)  eg: 'orange'
  AuthenticationMethod:     <--- Carrier auth method      (string)  eg: 'pap'
vpn_support:                <--- If VPN file must be sent (boolean) eg: false
vnc_support:                <--- Install VNC server       (boolean) eg: false
vnc_password:               <--- VNC password             (string)  eg: 'myvncpassword'
vnc_port:                   <--- VNC port                 (string)  eg: '5900'
run_specific                <--- Run specific.yml         (boolean) eg: false
```

### SSH
When setting `ssh_support: true`, the playbook will scan for file in `roles/cosmo-installation/files/ssh` and send them to `/home/user/.ssh` with correct right for common file

### VPN
When setting `vnc_support: true`, the playbook will scan for archive (prefered .tar.gz) in `roles/cosmo-installation/files/vpn` and send them to `/etc/openvpn/client` so you can run then using the injected script like `vpn (start|stop|restart|status) your_conf_name`

If your profile have a structure:
```
├── pro-ca.crt
├── pro-cert.crt
├── pro-key.key
├── pro-tls-auth.key
├── pro.conf
└── pro.tar.gz
```

They will be placed in `/etc/openvpn/client/` and you will start with `vpn start pro` (the `.conf` name without the extension)

### Mobile data
When setting `mobile_data_support: true`, the playbook will install LTE support, set correct carrier settings and start the service. If you need to change other settings or remove some (eg: your carrier doesn't require a password), you can delete/add settings key. It's dynamic: remove the key `Password`, add an other one, etc.

Example tree view of a working repo:
```
.
├── LICENSE
├── README.md
├── ansible.cfg
├── cosmo.yml
└── roles
    └── cosmo-installation
        ├── defaults
        │   └── main.yml
        ├── files
        │   ├── ssh
        │   │   ├── authorized_keys
        │   │   ├── config
        │   │   ├── id_rsa
        │   │   ├── id_rsa.pub
        │   │   └── known_hosts
        │   └── vpn
        │       ├── home.tar.gz
        │       └── pro.tar.gz
        ├── meta
        │   └── main.yml
        ├── tasks
        │   ├── core.yml
        │   ├── custom.yml
        │   ├── main.yml
        │   ├── mobile.yml
        │   ├── specific.yml
        │   ├── ssh.yml
        │   ├── vnc.yml
        │   └── vpn.yml
        └── templates
            ├── vnc_script.j2
            ├── vpn_script.j2
            └── zshrc.j2
```

### Touchscreen
There's two options you can use:
- `touch_rightclick`: Support for long press to trigger a right click if you want to keep the default driver with absolute positioning (you click exactly where you want).
- `touch_relative`: Use `mtrack` driver to change the Touchscreen behavior as a Touchpad with relative positioning (you drag your finder across the screen to where you want).

**Note:** If you set both options to `true`, only **touch_relative** will be installed

#### Mtrack settings
- `Sensitivity 1.2`: Increase speed
- `ScrollDistance 30`: Increase scrolling speed
- `ScrollUpButton and ScrollDownButton`: Correct the scrolling direction

Right click with two fingers tap.
Scroll with two fingers

---

## Usage
- Edit your settings in `cosmo.yml`
- Use the script `./start.sh` to build and launch the playbook within docker

---

## Steps description (63 tasks total)
- Core (32 tasks)
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
  - If `touch_relative`
    - Add mtrack conf file
  - If `touch_rightclick`
    - Download repo, make binary
    - Add as a service
  - If none
    - Ensure service rightclick is absent
    - Ensure mtrack conf is absent
  - Add xorg conf
  - Add general keyboard hotkey (LCD brightness, split screen, etc)
  - Add keyboard backlight script
  - Add keyboard backlight hotkey (5 levels)
- Custom (3 tasks)
  - Install oh-my-zsh
  - Add custom .zshrc
  - Add custom .vimrc
- [*optional*] SSH (4 tasks)
  - Add all SSH files contained in files/ssh
  - Fix rights for theses files
- [*optional*] Mobile data (6 tasks)
  - Install connman, cmst along with other for LTE support
  - Enable connman wifi connectivity
  - Enable roaming (*optional*)
  - Add carrier settings
  - Enable LTE
- [*optional*] VPN (5 tasks)
  - Install OpenVPN
  - Add all VPN profile contained in files/vpn
  - Add vpn startup script
- [*optional*] VNC (8 tasks)
  - Install VNC packages
  - Create password
  - Add autostart of the server
- [*optional*] Specific (5 tasks) <-- Given as example, put your own tasks here
  - Install Vault CLI
  - Install Ansible
