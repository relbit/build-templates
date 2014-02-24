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
%end
