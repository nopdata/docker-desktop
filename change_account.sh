#!/bin/bash


filelist = "Dockerfile docker-compose.yml files/init.sh"
echo -e "username: \c"
read username
echo -e "password: \c"
read -s password
echo 

for name in $filelist
do
	sed -i "s/<username>/$username/g" $name
	sed -i "s/<password>/$password/g" $name
done
echo "done."
