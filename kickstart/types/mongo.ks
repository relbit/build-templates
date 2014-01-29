%include /kickstart/include/base.ks
%include /kickstart/include/nscd.ks
%include /kickstart/include/root-bashrc.ks

%packages
mongo-10gen
mongo-10gen-server
%end

%post
chkconfig mongod on

service mongod start

mongo --eval "db = db.getSiblingDB('admin');db.addUser('admin', 'acjx197u');"

cat > /etc/mongod.conf <<"EOF"
logpath=/var/log/mongo/mongod.log
logappend=true
fork = true
dbpath=/var/lib/mongo
pidfilepath = /var/run/mongodb/mongod.pid
auth = true
EOF

cat > /etc/logrotate.d/mongo <<"EOF"
/var/log/mongo/mongod.log {
  daily
  missingok
  rotate 2
  compress
  notifempty
  create 640 mongod mongod
  sharedscripts
  postrotate
    killall -SIGUSR1 mongod
    find /var/log/mongo/ -type f -regex ".*\.\(log.[0-9].*-[0-9].*\)" -exec rm {};
  endscript
}
EOF

%end
