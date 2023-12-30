#!/bin/bash

# Supprot Model 
# 供應商資料: Hitron Technologies
# 型號: CGNF-TWN
# DOCSIS模式: DOCSIS 3.0
# 硬體版本: 1B
# 軟體版本: 3.1.1.44-GNR-1b3
# Boot Rom版本: PSPU-Boot 1.0.16.22-H2.9.3-AP

router_ip="192.168.0.1"
username="admin"
password="password"

# Define the md5 function
calculate_md5() {
    local value=$1
    curl -s --location "api.hashify.net/hash/md5/hex?value=$value" | jq -r '.Digest'
}

login_ret=$(curl -s -i -d "user=$username" -d "pws=$password" http://$router_ip/goform/login | grep 'userid=' | cut -f2 -d=|cut -f1 -d';')
echo -e "login_ret: " ${login_ret} "\n"

if [ -n "$login_ret" ] ; then
    csrf_ret=$(calculate_md5 $login_ret)
    # csrf_ret=$(echo -n ${login_ret} | md5)
    # echo -e "csrf_ret: " ${csrf_ret} "\n"

    echo -e "Rebooting Now ... \n"
    curl -s -H "Cookie: userid=$login_ret;" --data "dir=admin%2F&save=Reboot&csrf_value=$csrf_ret" http://$router_ip/goform/Cable > /dev/null
else
    # Login error.
    echo -e "Failed to login. \n"
    exit 0
fi

exit 1
