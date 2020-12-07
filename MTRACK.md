# Mtrack driver on Cosmo communicator
---
You can get the touchscreen working as a tracking with relative positioning (you click and drag on the screen to point where you want instead of touching where you want).

- Right click with 2 fingers.
- Scroll with 2 fingers work.

## Steps
1) Install the binary
```
sudo apt install xserver-xorg-input-mtrack
```
2) Edit `/usr/share/X11/xorg.conf.d/10-evdev.conf`
```
# Catch-all evdev loader for udev-based systems
# We don't simply match on any device since that also adds accelerometers
# and other devices that we don't really want to use. The list below
# matches everything but joysticks.

Section "InputClass"
        Identifier "evdev pointer catchall"
        MatchIsPointer "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection

Section "InputClass"
        Identifier "evdev keyboard catchall"
        MatchIsKeyboard "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection

Section "InputClass"
        Identifier "evdev touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection

Section "InputClass"
        Identifier "evdev tablet catchall"
        MatchIsTablet "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection
```
3) Edit `/usr/share/X11/xorg.conf.d/50-mtrack.conf`
```
Section "InputClass"
        Identifier "mtrack touchscreen catchall"
        MatchIsTouchscreen "on"
        MatchDevicePath "/dev/input/event*"
        Option "Sensitivity" "1.2"
        Option "ScrollDistance" "10"
        Option "ScrollUpButton" "5"
        Option "ScrollDownButton" "4"
        Driver "mtrack"
EndSection
```
4) Restart xorg
```
sudo systemctl restart display-manager
```