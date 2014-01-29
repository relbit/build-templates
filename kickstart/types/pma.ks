%include /kickstart/include/base.ks
%include /kickstart/include/httpd.ks
%include /kickstart/include/nscd.ks
%include /kickstart/include/php.ks
%include /kickstart/include/php-ioncube.ks
%include /kickstart/include/root-bashrc.ks

%packages
php-fpm
mod_fastcgi
%end

%post

PMA_VERSION="phpMyAdmin-3.5.8.1-all-languages"
PMA_URL="http://os.eviaproject.org/pma/${PMA_VERSION}.tar.gz"

mkdir -p /var/www/virtual/pma/htdocs
mkdir -p /var/www/virtual/pma/tmp
mkdir -p /var/www/virtual/pma/log
mkdir -p /var/www/virtual/pma/pma_versions
mkdir -p /var/www/virtual/pma/phpmyadmin/config

cat > /etc/php-fpm.d/pma.fcgi <<"EOF"
EOF

cat > /etc/php-fpm.d/pma.conf <<"EOF"
[pma]
listen = /etc/php-fpm.d/pma.sock
listen.allowed_clients = 127.0.0.1
user = apache
group = apache
pm = static
pm.max_children = 8
pm.start_servers = 32
pm.min_spare_servers = 1
pm.max_spare_servers = 8
pm.max_requests = 0 
pm.status_path = /status
slowlog = /var/log/php-fpm/www-slow.log
chdir = /var/www/virtual/pma/
php_admin_value[error_log] = /var/www/virtual/pma/log/www-error.log
php_admin_flag[log_errors] = on
php_admin_value[upload_tmp_dir] = /var/www/virtual/pma/tmp/
EOF

cat > /var/www/virtual/pma/phpmyadmin/www/.htaccess <<"EOF"
# PMA protection
	RewriteEngine On
	RewriteBase /
	RewriteCond %{HTTP_COOKIE} !^.*pma_logged.*$ [NC]
	RewriteRule .* / [F,NC,L]
EOF

cd /var/www/virtual/pma/pma_versions
curl -L $PMA_URL -o $PMA_VERSION.tar.gz
tar xf $PMA_VERSION.tar.gz
rm $PMA_VERSION.tar.gz

ln -sf /var/www/virtual/pma/pma_versions/$PMA_VERSION /var/www/virtual/pma/htdocs/phpmyadmin
ln -sf /var/www/virtual/pma/phpmyadmin/www/signon.php /var/www/virtual/pma/htdocs/signon.php
ln -sf /var/www/virtual/pma/phpmyadmin/www/.htaccess  /var/www/virtual/pma/htdocs/.htaccess

cat /var/www/virtual/pma/phpmyadmin/config/config.inc.php > <<"EOF"
<?php
$cfg['blowfish_secret'] = 'a8b7c6d';
$i = 0;
$i++;
$cfg['Servers'][$i]['extension']     = 'mysqli';
$cfg['Servers'][$i]['auth_type']     = 'signon';
$cfg['Servers'][$i]['SignonSession'] = 'SignonSession';
$cfg['Servers'][$i]['SignonURL']     = '../signon.php';
$cfg['Servers'][$i]['hide_db']       = 'information_schema'; 

$cfg['ShowStats']             = FALSE;
$cfg['ShowPhpInfo']           = FALSE;
$cfg['ShowServerInfo']        = FALSE;
$cfg['ThemeDefault']          = 'original';
$cfg['PmaNoRelation_DisableWarning'] = true;
$cfg['ShowCreateDb']          = FALSE;
$cfg['HideServerLinksTabs']   = array('status', 'settings', 'vars');
$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';
"EOF"

chown apache:apache -R /var/www/

%end
