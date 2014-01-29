%post

mkdir -p /etc/rc.local.d

cat > /etc/rc.d/rc.local <<"EOF"
#!/bin/sh
#
# This script will be executed *after* all the other init scripts.
# You can put your own initialization stuff in here if you don't
# want to do the full Sys V style init stuff.


# run all scripts from rc.local.d
for file in $( find /etc/rc.local.d/ -maxdepth 1  -type f -executable | sort -n ); do 
	$file; 
done

touch /var/lock/subsys/local
EOF

%end
