#!/bin/bash

service ssh restart
echo -e "<password>\n<password>" | passwd <username>
/startup.sh
