%post

cat > /etc/rc.local.d/10-mount-www_virtual <<"EOF"
#!/bin/bash

keypress=""
echo "Waiting for filesystems: /var/www/virtual [press any key to interrupt] ... \n"
while [ "`mount | grep '/var/www/virtual'`" == "" ]; do
        echo -n ".";
        mount /var/www/virtual > /dev/null 2>&1
        read -n 1 -t 1 keypress
        if [ "$keypress" != "" ]; then
            echo " interrupted."
            break;
        fi;
done
EOF
chmod +x /etc/rc.local.d/10-mount-www_virtual

cat > /etc/rc.local.d/30-start-httpd <<"EOF"
#!/bin/bash
/etc/init.d/httpd start
EOF
chmod +x /etc/rc.local.d/30-start-httpd
%end
