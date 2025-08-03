#!/usr/bin/env bash

set -e

FTP_GROUP="ftpusers"
FTP_USER="ftp"
FTP_DIR="/srv/ftp/upload"

# Create group if it doesn't exist
if ! getent group "$FTP_GROUP" > /dev/null; then
  echo "Creating group $FTP_GROUP"
  groupadd "$FTP_GROUP"
fi

# Check if user exists
if ! id "$FTP_USER" &> /dev/null; then
  echo "User $FTP_USER does not exist"
  echo "Creating user $FTP_USER as a member of group $FTP_GROUP"
  useradd -M -g "$FTP_GROUP" "$FTP_USER"
else
  echo "User $FTP_USER exists"
  # Check if user is a member of the group
  if id -nG "$FTP_USER" | grep -qw "$FTP_GROUP"; then
    echo "User $FTP_USER is already a member of group $FTP_GROUP"
  else
    echo "Adding user $FTP_USER to group $FTP_GROUP"
    usermod -a -G "$FTP_GROUP" "$FTP_USER"
  fi
fi

# Allow users with /usr/sbin/nologin shell to connect via FTP
echo "/usr/sbin/nologin" >> /etc/shells

# Set or update password
echo "Setting password for user $FTP_USER"
echo "$FTP_USER:$FTP_USER_PASSWORD" | chpasswd

# Ensure FTP directory exists
if [ ! -d "$FTP_DIR" ]; then
  echo "Creating directory $FTP_DIR"
  mkdir -p "$FTP_DIR"
fi

# Set group and permissions on ftp directory
echo "Updating group and permissions for $FTP_DIR"
chgrp -R "$FTP_GROUP" "$FTP_DIR"
chmod -R g+rwx "$FTP_DIR"

# Set timezone if TZ variable is provided
if [ -n "$TZ" ]; then
  echo "Setting timezone to $TZ"
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
  echo "$TZ" > /etc/timezone
  dpkg-reconfigure --frontend noninteractive tzdata
fi

# Check if PASV_ADDRESS is set, exit if not
if [ -z "$PASV_ADDRESS" ]; then
  echo "Error: PASV_ADDRESS environment variable is not set."
  exit 1
fi

# Replace placeholder in vsftpd config with PASV_ADDRESS
echo "Configuring vsftpd with PASV_ADDRESS=$PASV_ADDRESS"
sed "s/{{PASV_ADDRESS}}/${PASV_ADDRESS}/" /etc/vsftpd.conf.template > /etc/vsftpd.conf

exec "$@"