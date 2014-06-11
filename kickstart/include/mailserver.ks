%packages
dovecot
dovecot-mysql
dovecot-pigeonhole
postfix
postgrey
spamassassin
spamass-milter
%end

%post
yum remove -y sendmail sendmail-cf

/usr/sbin/useradd -c "Virtual Mail User" -u 250 -s /sbin/nologin -r -d /var/vmail vmail

chkconfig postfix	 off
chkconfig spamassassin	 off
chkconfig spamass-milter off
chkconfig postgrey	 off

mkdir -p /var/vmail
chown vmail:vmail /var/vmail
chmod 770 /var/vmail

cat > /etc/sysconfig/postgrey <<"EOF"
options="--unix=/var/spool/postfix/postgrey/socket --delay=60"
EOF

cat > /etc/sysconfig/spamassassin <<"EOF"
SPAMDOPTIONS="-d -c -m5 -H"
EOF

cat > /etc/sysconfig/spamass-milter <<"EOF"
SOCKET="inet:11120@[0.0.0.0]"
EXTRA_FLAGS="-m -r 15"
EOF
%end
