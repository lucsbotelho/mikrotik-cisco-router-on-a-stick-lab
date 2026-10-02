# 2026-10-02 02:54:40 by RouterOS 7.24.4
# system id = M/19GIFElsF
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
/interface vlan
add interface=ether2 name=vlan2-PRODUC vlan-id=2
add interface=ether2 name=vlan3-CONFEC vlan-id=3
/interface list
add name=WAN
add name=LAN
add name=WAN_CONN
add name="VLANS C/ INTERNET"
/ip pool
add name=dhcp ranges=10.10.0.3-10.10.0.254
add name=dhcp_pool1 ranges=10.10.3.2-10.10.3.254
add name=dhcp_pool2 ranges=10.10.2.2-10.10.2.254
add name=dhcp_pool3 ranges=10.10.2.2-10.10.2.254
add name=dhcp_pool4 ranges=10.10.3.2-10.10.3.254
/ip dhcp-server
add address-pool=dhcp interface=ether2 name=dhcp1
add address-pool=dhcp_pool3 interface=vlan2-PRODUC name=dhcp2
add address-pool=dhcp_pool4 interface=vlan3-CONFEC name=dhcp3
/interface list member
add interface=ether1 list=WAN
add interface=ether2 list=LAN
add interface=ether3 list=LAN
add interface=ether4 list=LAN
add interface=ether1 list=WAN_CONN
add interface=vlan3-CONFEC list="VLANS C/ INTERNET"
add interface=vlan2-PRODUC list="VLANS C/ INTERNET"
/ip address
add address=10.10.0.1/24 interface=ether2 network=10.10.0.0
add address=192.168.1.103/24 interface=ether1 network=192.168.1.0
add address=10.10.2.1/24 comment=PRODUCA interface=vlan2-PRODUC network=\
    10.10.2.0
add address=10.10.3.1/24 comment=CONFEC interface=vlan3-CONFEC network=\
    10.10.3.0
/ip dhcp-server network
add address=10.10.0.0/24 dns-server=10.10.0.1 gateway=10.10.0.1 netmask=24
add address=10.10.2.0/24 dns-server=8.8.8.8 gateway=10.10.2.1 netmask=24
add address=10.10.3.0/24 dns-server=1.1.1.3 gateway=10.10.3.1 netmask=24
/ip dns
set servers=::,::
/ip firewall filter
add action=reject chain=forward comment="BLOQUEIO DE INTER-VLAN TOTAL" \
    in-interface=vlan2-PRODUC log=yes out-interface=vlan3-CONFEC reject-with=\
    icmp-admin-prohibited
add action=reject chain=forward comment="BLOQUEIO DE INTER-VLAN TOTAL" \
    in-interface=vlan3-CONFEC out-interface=vlan2-PRODUC reject-with=\
    icmp-admin-prohibited
/ip firewall nat
add action=masquerade chain=srcnat comment="SA\C3\8DDA WAN" \
    in-interface-list="VLANS C/ INTERNET" log=yes out-interface=ether1
add action=masquerade chain=srcnat comment="SAIDA DE GRUPO DE LINKS WAN" \
    disabled=yes ipsec-policy=out,none out-interface-list=WAN
/ip route
add disabled=no dst-address=0.0.0.0/0 gateway=192.168.1.1
/system identity
set name=border-router
