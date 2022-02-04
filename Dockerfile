FROM dorowu/ubuntu-desktop-lxde-vnc:latest
LABEL maintainer="nopdata00@gmail.com"

ENV HOME=/home/<username>
RUN useradd -m <username> -d /home/<username> -s /bin/bash
RUN echo '<username> ALL=(ALL:ALL) ALL' >> /etc/sudoers

# install default programm
RUN apt-get update
RUN apt-get install python3-pip git -y
RUN apt-get install openjdk-11-jdk -y
RUN apt-get install vim -y

# install gdb, peda, pwndbg, gef
RUN apt-get install gdb -y
RUN mkdir /dbg

# install pwndbg
WORKDIR /dbg
RUN git clone https://github.com/pwndbg/pwndbg
WORKDIR /dbg/pwndbg/
RUN /dbg/pwndbg/setup.sh
RUN echo 'define init-pwndbg\nsource /dbg/pwndbg/gdbinit.py\nend\ndocument init-pwndbg\nInitializes PwnDBG\nend\n\n' > /home/<username>/.gdbinit
RUN echo 'define init-pwndbg\nsource /dbg/pwndbg/gdbinit.py\nend\ndocument init-pwndbg\nInitializes PwnDBG\nend\n\n' > /root/.gdbinit
RUN echo '#!/bin/sh\nexec gdb -q -ex init-pwndbg "$@"' > /usr/bin/gdb-pwndbg
RUN chmod +x /usr/bin/gdb-pwndbg

# install peda
WORKDIR /dbg
RUN git clone https://github.com/longld/peda
RUN echo 'define init-peda\nsource /dbg/peda/peda.py\nend\ndocument init-peda\nInitializes the PEDA (Python Exploit Development Assistant for GDB) framework\nend\n\n' >> /home/<username>/.gdbinit
RUN echo 'define init-peda\nsource /dbg/peda/peda.py\nend\ndocument init-peda\nInitializes the PEDA (Python Exploit Development Assistant for GDB) framework\nend\n\n' >> /root/.gdbinit
RUN echo '#!/bin/sh\nexec gdb -q -ex init-peda "$@"' > /usr/bin/gdb-peda
RUN chmod +x /usr/bin/gdb-peda

# install gef
WORKDIR /dbg
RUN wget -q -O .gdbinit-gef.py https://github.com/hugsy/gef/raw/master/gef.py
RUN echo 'define init-gef\nsource /dbg/.gdbinit-gef.py\nend\ndocument init-gef\nInitializes GEF (GDB Enhanced Features)\nend\n\n' >> /home/<username>/.gdbinit
RUN echo 'define init-gef\nsource /dbg/.gdbinit-gef.py\nend\ndocument init-gef\nInitializes GEF (GDB Enhanced Features)\nend\n\n' >> /root/.gdbinit
RUN echo '#!/bin/sh\nexec gdb -q -ex init-gef "$@"' > /usr/bin/gdb-gef
RUN chmod +x /usr/bin/gdb-gef

# install metasploit
RUN curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > /srv/msfinstall 
RUN chmod 755 /srv/msfinstall
RUN /srv/msfinstall


# install ssh server
RUN apt-get install openssh-server -y

# install binwalk
RUN apt-get install binwalk -y

# install john the ripper
RUN apt-get install john -y
RUN mkdir /srv/tool
RUN mkdir /srv/tool/wordlist
WORKDIR /srv/tool/wordlist
RUN wget https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt

# install enum
WORKDIR /srv/tool
RUN git clone https://github.com/rebootuser/LinEnum

# install i386 library
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 -y

# install ping
RUN apt-get install iputils-ping -y

# install nmap
RUN apt-get install nmap -y

# install openvpn
RUN apt-get install openvpn -y

# install wpscan
RUN apt-get install ruby ruby-dev libcurl4-openssl-dev make -y
WORKDIR /srv/tool
RUN git clone https://github.com/wpscanteam/wpscan
WORKDIR /srv/tool/wpscan
RUN gem install bundler && bundler install --without test
RUN gem install wpscan
RUN wpscan --update

# install pwntools
RUN apt-get install libssl-dev -y
RUN apt-get install libffi-dev -y
RUN python -m pip install --upgrade pwntools

# install go
RUN apt-get install golang-go -y

# install waybackurls
RUN go get github.com/tomnomnom/waybackurls
RUN ln -s /home/<username>/go/bin/waybackurls /usr/bin/waybackurls

# install ghidra
WORKDIR /srv/tool
RUN wget $(curl -s https://api.github.com/repos/NationalSecurityAgency/ghidra/releases/latest | grep 'browser_' | cut -d\" -f4) -O ghidra.zip
RUN unzip ghidra.zip
RUN rm ghidra.zip
RUN mv $(ls | grep ghidra) ghidra

# install burpsuite
WORKDIR /srv/tool
RUN wget "https://portswigger.net/burp/releases/download?product=community" -O burpsuite.jar

# install dirb
RUN apt-get install dirb -y

# install ffuf
RUN go get github.com/ffuf/ffuf
RUN ln -s /home/<username>/go/bin/ffuf /usr/bin/ffuf

# install arjun
WORKDIR /srv/tool
RUN git clone https://github.com/s0md3v/arjun
WORKDIR /srv/tool/arjun
RUN python setup.py install

# install knock
WORKDIR /srv/tool
RUN git clone https://github.com/guelfoweb/knock
WORKDIR /srv/tool/knock
RUN python -m pip install -r requirements.txt
RUN python setup.py install

# install sqlmap
WORKDIR /srv/tool
RUN git clone --depth 1 https://github.com/sqlmapproject/sqlmap
RUN echo 'python /srv/tool/sqlmap/sqlmap.py "$@"' > /usr/bin/sqlmap
RUN chmod +x /usr/bin/sqlmap

# install sublist3r
WORKDIR /srv/tool
RUN git clone https://github.com/aboul3la/Sublist3r.git

# install whatweb
WORKDIR /srv/tool
RUN git clone https://github.com/urbanadventurer/WhatWeb
RUN ln -s /srv/tool/WhatWeb/whatweb /usr/bin/whatweb

# install netcat
RUN apt-get install netcat -y

# init script
COPY files/init.sh /srv/init.sh
RUN chmod +x /srv/init.sh

ENTRYPOINT ["/srv/init.sh"]
