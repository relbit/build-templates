%include /kickstart/include/base.ks
%include /kickstart/include/nscd.ks
%include /kickstart/include/root-bashrc.ks

%packages
postfix
%end

%post
chkconfig postfix on
%end
