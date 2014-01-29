%include /kickstart/include/base.ks
%include /kickstart/include/nscd.ks
%include /kickstart/include/root-bashrc.ks

%packages
iptables
iptables-ipv6
%end

%post
chkconfig iptables on
chkconfig ip6tables on

cat >> /etc/sysctl.conf <<"EOF"
net.ipv4.tcp_keepalive_time = 60
net.ipv4.tcp_keepalive_intvl = 5
net.ipv4.tcp_keepalive_probes = 6
net.ipv4.ip_forward = 1
EOF

cat > /etc/sysconfig/iptables <<"EOF"
*mangle
:PREROUTING ACCEPT [83:6236]
:INPUT ACCEPT [83:6236]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [47:5220]
:POSTROUTING ACCEPT [47:5220]
COMMIT
*filter
:INPUT ACCEPT [83:6236]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [46:5120]
COMMIT
EOF

cat > /etc/sysconfig/ip6tables <<"EOF"
*mangle
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
COMMIT
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
COMMIT
EOF
%end
