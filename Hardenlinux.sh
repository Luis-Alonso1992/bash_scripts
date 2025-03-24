#!/bin/bash
#Remove Password Authentication for SSH Login
sed -i -E 's/#PasswordAuthentication (yes|no)/PasswordAuthentication No/' /etc/ssh/sshd_cosudonfig
sudo systemctl restart sshd