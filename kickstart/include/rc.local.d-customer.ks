%post
cat > /etc/rc.local.d/10-mount-www_confs <<"EOF"
#!/bin/bash
keypress=""
echo "Waiting for filesystems: /var/www/confs [press any key to interrupt] ... \n"
while [ "`mount | grep '/var/www/confs'`" == "" ]; do
        echo -n ".";
        mount /var/www/confs > /dev/null 2>&1
        read -n 1 -t 1 keypress
        if [ "$keypress" != "" ]; then
            echo " interrupted."
            break;
        fi;
done
EOF

cat > /etc/rc.local.d/11-mount-www_virtual <<"EOF"
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

cat > /etc/rc.local.d/12-mount-sites_d <<"EOF"
#!/bin/bash

keypress=""
echo "Waiting for filesystems: /etc/httpd/sites.d [press any key to interrupt] ... \n"
while [ "`mount | grep '/etc/httpd/sites.d '`" == "" ]; do
        echo -n ".";
        mount /etc/httpd/sites.d  > /dev/null 2>&1
        read -n 1 -t 1 keypress
        if [ "$keypress" != "" ]; then
            echo " interrupted."
            break;
        fi;
done
EOF

cat > /etc/rc.local.d/20-start-httpd <<"EOF"
#!/bin/bash
/etc/init.d/httpd start
EOF
%end
