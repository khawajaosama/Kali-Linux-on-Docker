FROM kalilinux/kali-linux-docker

RUN apt update
RUN apt dist-upgrade
RUN apt autoremove
RUN apt clean

RUN apt install kali-linux-top10