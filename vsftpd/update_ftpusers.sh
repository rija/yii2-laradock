#!/bin/sh
# A shell script to update FTP users
# Written by: Peter Li
# Last updated on: Sep/28/2016
# -------------------------------------------

echo "hi there" >> /tmp/test
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

set -e
set -u

PSQL=/usr/bin/psql

DB_USER=gigadb
DB_HOST=postgres
DB_NAME=ftpusers
export PGPASSWORD=vagrant

# Iterates through a result set
$PSQL \
  -X \
  -h $DB_HOST \
  -U $DB_USER \
  -c "select name, password from ftp_user;" \
  --single-transaction \
  --set AUTOCOMMIT=off \
  --set ON_ERROR_STOP=on \
  --no-align \
  -t \
  --field-separator ' ' \
  --quiet \
  -d $DB_NAME \
| while read name passwd ; do
  echo ${name}
  ret=false
  getent passwd ${name} >/dev/null 2>&1 && ret=true
  # Check if user exists
  if $ret; then
    echo "yes ${name} user exists"
    # Update password for user
    echo ${name}:${passwd} | chpasswd
  else
    echo "No, ${name} user does not exist"
    # Create account for user
    useradd -c "${name}" -m ${name}
    # Add password for user
    echo ${name}:${passwd} | chpasswd
    # Create ftp user config file
    touch /etc/vsftpd/users.d/${name}
    echo "local_root="/mnt/temporary_upload/${name} > /etc/vsftpd/users.d/${name}
    # Create directory for user to upload files by FTP
    mkdir -p /mnt/temporary_upload/${name}
    chown ${name}:${name} /mnt/temporary_upload/${name}
    chmod 0700 /mnt/temporary_upload/${name}

    # Create home dir and update vsftpd user db
    # mkdir -p "/home/vsftpd/${FTP_USER}"
    echo -e "${name}\n${passwd}" > /etc/vsftpd/virtual_users.txt
    /usr/bin/db_load -T -t hash -f /etc/vsftpd/virtual_users.txt /etc/vsftpd/virtual_users.db
  fi
done
