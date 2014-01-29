%post
cat > /root/.bashrc <<"EOF"
# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vi='vim'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

umask 022
PS1="[\[\e[1;31m\]\u\[\e[0;00m\]@\[\e[1;31m\]\H\[\e[0;00m\]]\n \w \[\e[1;31m\]# \[\e[0;00m\]"
EOF
%end
