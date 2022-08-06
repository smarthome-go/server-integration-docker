FROM archlinux:latest

LABEL author="MikMuellerDev"

# Install required software
RUN pacman -Syu --noconfirm \
    && pacman -S base-devel git mariadb go --noconfirm

# Install mariadb
RUN mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
RUN echo 'port=3330' >> /etc/my.cnf

# Create future workdir
RUN mkdir -p /opt/smarthome/tests

# Prepare the entrypoint script
COPY ./entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
