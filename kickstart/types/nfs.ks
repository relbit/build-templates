%include /kickstart/include/base.ks
%include /kickstart/include/nfs.ks
%include /kickstart/include/nscd.ks
%include /kickstart/include/nss-mysql.ks
%include /kickstart/include/mysql-client.ks
%include /kickstart/include/rc.local.d.ks
%include /kickstart/include/root-bashrc.ks

%packages
proftpd
proftpd-mysql
%end

%post
chkconfig proftpd on

mkdir -p /storage/var/www/confs
mkdir -p /storage/var/www/virtual
mkdir -p /storage/etc/httpd/sites.d

cat > /storage/etc/httpd/php.fcgi <<"EOF"
#!/bin/bash
USER=$(/usr/bin/whoami)
PHP_FCGI_CHILDREN=2
PHP_FCGI_MAX_REQUESTS=500
export PHP_FCGI_CHILDREN
export PHP_FCGI_MAX_REQUESTS

exec /usr/bin/php5-cgi $@
EOF
%end
