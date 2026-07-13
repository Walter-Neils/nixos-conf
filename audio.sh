bluetoothctl remove 98:67:2E:EB:D8:92
rm -rf ~/.local/state/wireplumber/

sudo systemctl stop bluetooth
# 3. Wipe the system Bluetooth cache 
sudo rm -rf /var/lib/bluetooth/*

# 4. Restart the bluetooth system service
sudo systemctl restart bluetooth
systemctl --user restart pipewire wireplumber pipewire-pulse
