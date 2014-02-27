%packages
php53-fpm
%end

%post
cat > /etc/rc.local.d/20-start-php-fpm <<"EOF"
#!/bin/bash 
/etc/init.d/php-fpm start
EOF

chmod +x /etc/rc.local.d/20-start-php-fpm

chkconfig --add php-fpm

cat > /etc/php-fpm.d/dummy.conf <<"EOF"
[dummy]

listen = 127.0.0.1:9000
listen.allowed_clients = 127.0.0.1

user = apache
group = apache

pm = dynamic
pm.max_children = 1
pm.start_servers = 1
pm.min_spare_servers = 1
pm.max_spare_servers = 1
EOF

cat > /etc/php-fpm.d/dummy.fcgi <<"EOF"
#!/bin/bash

EOF
chown apache:apache /etc/php-fpm.d/dummy.fcgi
chmod 755 /etc/php-fpm.d/dummy.fcgi

cat > /etc/logrotate.d/php-fpm <<"EOF"
/var/log/php-fpm/error.log {
    weekly
    missingok
    notifempty
    dateext
    rotate 1
    postrotate
        /sbin/service php-fpm reload > /dev/null 2>/dev/null || true
    endscript
}
EOF

%end
