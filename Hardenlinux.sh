#!/bin/bash
#Remove Password Authentication for SSH Login
sed -i 's/#PasswordAuthentication Yes/PasswordAuthentication No/g' /etc/ssh/sshd_config