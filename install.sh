#!/usr/bin/env bash

VERSION="2.0.5"
ORIENTDB_DIR="/opt/orientdb"
ORIENTDB_USER="orientdb"

sudo apt-get update
sudo apt-get -y install build-essential curl python-software-properties 

# orientdb
if [[ ! -f /opt/orientdb/bin/server.sh ]]; then
  echo 'Installing orientdb' 
  
  sudo apt-get install -y default-jre
  
  if [[ ! -f orientdb.tar.gz ]]; then
    wget https://covve.blob.core.windows.net/deployment-files/orientdb-community-2.0.5.tar.gz -O orientdb.tar.gz
  fi
  
  # extract orientdb to /opt/orientdb
  sudo tar xvzf orientdb.tar.gz -C /opt/
  sudo ln -s /opt/orientdb-community-2.0.5/ /opt/orientdb
  
  # set root user password and remove read permissions
  sudo sed -i 's/<users>/<users>\n\t<user name="root" password="root" resources="*" \/>/' /opt/orientdb/config/orientdb-server-config.xml
  sudo chmod 640 /opt/orientdb/config/orientdb-server-config.xml

  # create user and set rights
  printf "*** Creating '${ORIENTDB_USER}' user ...\n"
  sudo useradd -d ${ORIENTDB_DIR} -M -r -s /bin/false -U ${ORIENTDB_USER}
  chown -R ${ORIENTDB_USER}:${ORIENTDB_USER} ${ORIENTDB_DIR}*
  sudo chmod 775 ${ORIENTDB_DIR}/bin
  sudo chmod g+x ${ORIENTDB_DIR}/bin/*.sh
  sudo usermod -a -G ${ORIENTDB_USER} vagrant
fi

if [[ ! -f /etc/init.d/orientdb ]]; then
  # make orientdb to start as a service
  sudo cp ${ORIENTDB_DIR}/bin/orientdb.sh /etc/init.d/orientdb
  sudo sed -i "s|YOUR_ORIENTDB_INSTALLATION_PATH|${ORIENTDB_DIR}|;s|USER_YOU_WANT_ORIENTDB_RUN_WITH|${ORIENTDB_USER}|" /etc/init.d/orientdb
  sudo sed -i 's|su $ORIENTDB_USER -c|sudo -u $ORIENTDB_USER sh -c|' /etc/init.d/orientdb
  sudo update-rc.d orientdb defaults
fi

echo 'Starting orientdb server'
sudo /etc/init.d/orientdb start

printf "\nInstallation Complete\n"
printf "=====================\n"
printf "Root directory is: ${ORIENTDB_DIR}\n"
printf "Created User/Group: ${ORIENTDB_USER}\n"
printf "Java Version Installed:\n"
java -version
printf "\n"

echo 'Done!'vagrant