#!/bin/sh


install_hostname()
{
    # set hostname
    hostname ${HOST_NAME}
    if [ -f /etc/tlinux-release ]
    then
        echo HOSTNAME=$(hostname) >> /etc/sysconfig/network
    else
        hostname > /etc/HOSTNAME
    fi

    rm -f /usr/local/agenttools/agent/plugins/sysinfo_xml
    echo "[OK]:hostname set successfully"
}


HOST_NAME=$1

install_hostname 


