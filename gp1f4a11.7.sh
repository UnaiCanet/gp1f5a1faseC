#!/bin/bash

ver=$(grep "Versió:" /var/lib/jenkins/workspace/app/README | cut -d ":" -f 2 | tr -d '[:space:]')
ver_ant=$(grep "Versió anterior" /var/lib/jenkins/workspace/app/README | cut -d ":" -f 2 | tr -d '[:space:]')

ssh vagrant@produccio1 "mkdir -p /home/vagrant/app/aplicacion/$ver"

scp -r /var/lib/jenkins/workspace/app/* vagrant@produccio1:/home/vagrant/app/aplicacion/$ver/

if [[ ! -z $ver_ant ]]; then
    comprova=$(ssh vagrant@produccio1 ls /home/vagrant/app/aplicacion/ | grep $ver_ant)
    if [[ ! -z $comprova ]]; then
        ssh vagrant@produccio1 "rm -rf /home/vagrant/app/aplicacion/$ver_ant"
    fi
fi

ssh vagrant@produccio1 "docker-compose -f /home/vagrant/app/aplicacion/$ver/docker-compose.yml up -d"

exit 0
