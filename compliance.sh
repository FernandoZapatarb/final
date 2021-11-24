#/bin/bash
#Author: Fernando Zapata Robles, Carlos Covarrubias, Juan 
#22/11/2021
#version: final

# TCP SYN Cookies enable

if sysctl net.ipv4.tcp_syncookies | egrep 'net.ipv4.tcp_syncookies = 1'
then
        echo "First condition is True"
        c1=true
else
        echo "Firts condition is False"
        c1=false
fi

if grep "net\.ipv4\.tcp_syncookies" /etc/sysctl.conf /etc/sysctl.d/*.conf | egrep '/etc/sysctl.d/60-gce-network-security.conf:net.ipv4.tcp_syncookies=1'
then
        echo "Second condition is True"
        c2=true
else
        echo "Second condition is False"
        c2=false
fi

if $c1 AND $c2
then
        #echo "net.ipv4.tcp_syncookies = 1" >> /home/marce/RESULTADO
        echo "TCP SYN cookies enable"
else
        echo "Repairing..."
        sudo sysctl - w net.ipv4.tcp_syncookies=1
fi

#BOGUS ICMP
if sysctl net.ipv4.icmp_ignore_bogus_error_responses | egrep 'net.ipv4.icmp_ignore_bogus_error_responses = 1'
then
        echo "First condition is True"
        c1=true
else
        echo "Firts condition is False"
        c1=false
fi
if grep "net.ipv4.icmp_ignore_bogus_error_responses" /etc/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf | egrep '/etc/sysctl.d/60-gce-network-security.conf:net.ipv4.icmp_ignore_bogus_error_responses=1'
then
        echo "first condition is true"
        c2=true
else
        echo "second condition is false"
        c2=false
fi

if $c1 AND $c2
then
        echo "Bogus is fine"
else
        echo "Repairing ..."
        sudo sysctl - w net.ipv4.icmp_ignore_bogus_error_responses=1
fi


#BROADCAST ICMP
if sysctl net.ipv4.icmp_echo_ignore_broadcasts | egrep 'net.ipv4.icmp_echo_ignore_broadcasts = 1'
then
        echo "First condition is True"
        c1=true
else
        echo "Firts condition is False"
        c1=false
fi

if grep "net\.ipv4\.icmp_echo_ignore_broadcasts" /etc/sysctl.d/*.conf | egrep '.*net.ipv4.icmp_echo_ignore_broadcasts=1'
then
        echo "Second condition is true"
        c2=true
else
        echo "second condition is false"
        c2=false
fi

if $c1 AND $c2
then
        echo "Broadcast ICMP is fine"
else
        echo "Repairing ..."
        sudo sysctl - w net.ipv4.icmp_echo_ignore_broadcasts=1
fi


# Core Dumps

if sysctl fs.suid_dumpable | egrep 'fs.suid_dumpable = 0'
then
        echo "First condition is True"
        c1=true
else
        echo "Firts condition is False"
        c1=false
fi

if grep  grep "fs\.suid_dumpable" /etc/sysctl.d/* | egrep 'fs.suid_dumpable = 0'

then
        echo "Second condition is True"
        c2=true
else
        echo "Second condition is False"
        c2=false
fi

if $c1 AND $c2
then
        #echo "net.ipv4.tcp_syncookies = 1" >> /home/marce/RESULTADO
        echo "Core dumps Ok"
else
        echo "Repairing..."
        sudo sysctl - w fs.suid_dumpable=0
fi

#3.2.1

sysctl net.ipv4.ip_forward | grep -E "net.ipv4.ip_forward = 0"
if [[ $? ==  0 ]] ; then
        exit 0
fi

if [[ $(ls -A /etc/sysctl.d/) ]] ; then
	grep "net.ipv4.ip_forward" /etc/sysctl.conf /etc/sysctl.d/* | grep -E "net.ipv4.ip_forward = 0" || exit $?
else
	grep "net.ipv4.ip_forward" /etc/sysctl.conf | grep -E "net.ipv4.ip_forward = 0" || exit $?
fi

#3.3.2
sysctl net.ipv4.conf.all.accept_redirects | grep -E "net.ipv4.conf.all.accept_redirects = 0"
if [[ $? == 0 ]]; then
	exit 0
fi

if [[ $(ls -A /etc/sysctl.d/) ]]; then
	grep "net.ipv4.conf.all.accept_redirects" /etc/sysctl.conf /etc/sysctl.d/* | grep -E "net.ipv4.conf.all.accept_redirects = 0" || exit $?
else
	grep "net.ipv4.conf.all.accept_redirects" /etc/sysctl.conf | grep -E "net.ipv4.conf.all.accept_redirects = 0" || exit $?

fi

sysctl net.ipv4.conf.default.accept_redirects | grep -E "net.ipv4.conf.default.accept_redirects = 0"
if [[ $? == 0 ]]; then
	exit 0
fi

if [[ $(ls -A /etc/sysctl.d/) ]]; then
	grep "net.ipv4.conf.default.accept_redirects" /etc/sysctl.conf /etc/sysctl.d/* | grep -E "net.ipv4.conf.default.accept_redirects = 0" || exit $?
else
	grep "net.ipv4.conf.default.accept_redirects" /etc/sysctl.conf | grep -E "net.ipv4.conf.default.accept_redirects = 0" || exit $?
