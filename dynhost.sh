#! /bin/sh
################################################################################
# Copyright (C) 2017 Florent VIOLLEAU
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the MIT license
#
#################################################################################
# Logfile: dynhost.log
#
# CHANGE: « HOST », « LOGIN », « PASSWORD », « LOG_PATH » and « LIVEBOX » to reflect YOUR account variables
# OR: use, in argument, a custom file that contains « HOST », « LOGIN », « PASSWORD », « LOG_PATH » and « LIVEBOX »

if [ -f "$1" ]; then
  . $1
else
  # HOST can be a domain or a sub-domain
  HOST='sub-domain.you-domain.fr'
  # LOGIN is the one you created in ovh manager (see Readme file)
  LOGIN='you-domain-LOGIN'
  # PASSWORD is the one you created in ovh manager (see Readme file)
  PASSWORD='password'
  LOG_PATH='/var/log/dynhost'
  LIVEBOX='192.168.1.1'
fi

# Check binaries
type curl >/dev/null 2>&1 || { echo "I require curl but it's not installed.  Aborting." 2>&1 | tee -a $LOG_PATH/dynhost.log; exit 1; }
type wget >/dev/null 2>&1 || { echo "I require wget but it's not installed.  Aborting." 2>&1 | tee -a $LOG_PATH/dynhost.log; exit 1; }
type sed >/dev/null 2>&1 || { echo "I require sed but it's not installed.  Aborting." 2>&1 | tee -a $LOG_PATH/dynhost.log; exit 1; }
type dig >/dev/null 2>&1 || { echo "I require dig but it's not installed.  Aborting." 2>&1 | tee -a $LOG_PATH/dynhost.log; exit 1; }

echo '----------------------------------' >> $LOG_PATH/dynhost.log
echo `date` >> $LOG_PATH/dynhost.log
echo 'DynHost' >> $LOG_PATH/dynhost.log

IP=`curl -s -X POST -H "Content-Type: application/json" -d '{"parameters":{}}'  http://$LIVEBOX/sysbus/NMC:getWANStatus | sed -e 's/.*"IPAddress":"\(.*\)","Remo.*/\1/g'`
IPv6=`curl -s -X POST -H "Content-Type: application/json" -d '{"parameters":{}}'  http://$LIVEBOX/sysbus/NMC:getWANStatus | sed -e 's/.*"IPv6Address":"\(.*\)","IPv6D.*/\1/g'`
OLDIP=`dig +short @$LIVEBOX $HOST`

if [ "$IP" ]; then
  if [ "$OLDIP" != "$IP" ]; then
    echo -n "Old IP: [$OLDIP]" >> $LOG_PATH/dynhost.log
    echo -n "New IP: [$IP]" >> $LOG_PATH/dynhost.log
    RESULT=`wget -q -O - 'http://www.ovh.com/nic/update?system=dyndns&hostname='$HOST'&myip='$IP --user=$LOGIN --password=$PASSWORD >> $LOG_PATH/dynhost.log`
    echo "Result: $RESULT" >> $LOG_PATH/dynhost.log
    if [[ $RESULT =~ ^(good|nochg).* ]]; then
      echo ---------------------------------- >> $LOG_PATH/dynhost-changes.log
      echo `date` >> $LOG_PATH/dynhost-changes.log
      echo "New IP : $IP" >> $LOG_PATH/dynhost-changes.log
    fi
  else
    echo "Notice: IP $HOST [$OLDIP] is identical to WAN [$IP]! No update required." >> $LOG_PATH/dynhost.log
  fi
else
  echo "Error: WAN IP not found. Exiting!" >> $LOG_PATH/dynhost.log
fi
