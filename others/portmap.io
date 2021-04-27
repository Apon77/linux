# Openvpn method to forward port 22 from local pc
Configuration > new configuration > openvpn > tcp > name > generate > download wasker.first.ovpn
Mapping rule > protocol tcp > port on pc 22 > allowed ip blank > create
sudo apt install openvpn
sudo openvpn --config wasker.first.ovpn
# in any pc
Server will be available at mapping rule with that random port

# SSH method
# Same like openvpn method
