#!/bin/bash
mkdir files/dbg
cd files/dbg
git clone https://github.com/pwndbg/pwndbg
mv pwndbg pwndbg-src
git clone https://github.com/longld/peda
mv peda peda-src
wget -q -O .gdbinit-gef.py https://github.com/hugsy/gef/raw/master/gef.py
cd ..
tar -czvf dbg.tar.gz dbg
rm dbg -r
wget $(curl -s https://api.github.com/repos/NationalSecurityAgency/ghidra/releases/latest | grep 'browser_' | cut -d\" -f4) -O ghidra.zip
wget "https://portswigger.net/burp/releases/download?product=community" -O burpsuite.jar
