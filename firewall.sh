IPT="/sbin/iptables"

$IPT -F
$IPT -X

default_policy="DROP"

$IPT -P INPUT $default_policy
$IPT -P OUTPUT $default_policy
$IPT -P FORWARD $default_policy


# user defined chains
$IPT -N ALLTraffic
$IPT -N SSHTraffic
$IPT -N WWWTraffic
$IPT -N HTTPSTraffic


$IPT -A ALLTraffic
$IPT -A INPUT -j ALLTraffic
$IPT -A OUTPUT -j ALLTraffic

$IPT -A SSHTraffic
$IPT -A INPUT -p tcp --dport ssh -j SSHTraffic
$IPT -A INPUT -p tcp --sport ssh -j SSHTraffic
$IPT -A OUTPUT -p tcp --dport ssh -j SSHTraffic
$IPT -A OUTPUT -p tcp --sport ssh -j SSHTraffic

$IPT -A WWWTraffic
$IPT -A INPUT -p tcp --dport www -j WWWTraffic
$IPT -A INPUT -p tcp --sport www -j WWWTraffic
$IPT -A OUTPUT -p tcp --dport www -j WWWTraffic
$IPT -A OUTPUT -p tcp --sport www -j WWWTraffic

$IPT -A HTTPSTraffic
$IPT -A INPUT -p tcp --dport 443 -j HTTPSTraffic
$IPT -A INPUT -p tcp --sport 443 -j HTTPSTraffic
$IPT -A OUTPUT -p tcp --dport 443 -j HTTPSTraffic
$IPT -A OUTPUT -p tcp --sport 443 -j HTTPSTraffic


#drop in/out bound traffic to port 80 from source ports less than 1024.
$IPT -A INPUT -p tcp --dport 80 --sport 0:1023 -j DROP
$IPT -A OUTPUT -p tcp --sport 80 --dport 0:1023 -j DROP
$IPT -A INPUT -p tcp --dport 80 ! --sport 0:1023 -j ACCEPT
$IPT -A OUTPUT -p tcp --sport 80 ! --dport 0:1023 -j ACCEPT

#Allow outbound http requests
$IPT -A OUTPUT -p tcp --dport 80 -j ACCEPT
$IPT -A INPUT -p tcp --sport 80 -j ACCEPT

#drop all in/out bound packets from reserved port 0
$IPT -A INPUT -p tcp --sport 0 -j DROP
$IPT -A INPUT -p udp --sport 0 -j DROP
$IPT -A OUTPUT -p tcp --dport 0 -j DROP
$IPT -A OUTPUT -p udp --dport 0 -j DROP

#allow DHCP traffic
$IPT -A OUTPUT -p udp --dport 67:68 -j ACCEPT
$IPT -A INPUT -p udp --sport 67:68 -j ACCEPT

#allow DNS tcp and udp traffic
$IPT -A OUTPUT -p tcp --dport 53 -j ACCEPT
$IPT -A INPUT -p tcp --sport 53 -j ACCEPT
$IPT -A OUTPUT -p udp --dport 53 -j ACCEPT
$IPT -A INPUT -p udp --sport 53 -j ACCEPT

#allow https and udp traffic
$IPT -A OUTPUT -p tcp --dport 443 -j ACCEPT
$IPT -A INPUT -p tcp --sport 443 -j ACCEPT
$IPT -A OUTPUT -p tcp --sport 443 -j ACCEPT
$IPT -A INPUT -p tcp --dport 443 -j ACCEPT

$IPT -A OUTPUT -p udp --dport 443 -j ACCEPT
$IPT -A INPUT -p udp --sport 443 -j ACCEPT
$IPT -A OUTPUT -p udp --sport 443 -j ACCEPT
$IPT -A INPUT -p udp --dport 443 -j ACCEPT

#allow ssh in/out bound traffic
$IPT -A OUTPUT -p tcp --sport 22 -j ACCEPT
$IPT -A INPUT -p tcp --dport 22 -j ACCEPT
$IPT -A OUTPUT -p tcp --dport 22 -j ACCEPT
$IPT -A INPUT -p tcp --sport 22 -j ACCEPT
