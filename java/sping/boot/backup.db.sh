#!/bin/bash


db=mall
location=`pwd`
time=$(date "+%Y%m%d_%H%M")
suffix=backup.sql


mysqldump --defaults-extra-file=/etc/my.cnf ${db} > ${location}/${db}-${time}-${suffix}


echo 'database' ${db} 'backup success!'
