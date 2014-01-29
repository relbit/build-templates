%packages
unzip
%end

%post
IONCUBE_URL="http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.zip"
IONCUBE_FILE="ioncube_loader_lin_5.3.so"

cd /tmp
curl -s -L $IONCUBE_URL -o /tmp/ioncube.zip
unzip ioncube.zip
cp ioncube/$IONCUBE_FILE /usr/lib64/php/modules/
rm -Rf /tmp/ioncube*

cat > /etc/php.d/ioncube.ini <<EOF
zend_extension=/usr/lib64/php/modules/$IONCUBE_FILE
EOF
%end
