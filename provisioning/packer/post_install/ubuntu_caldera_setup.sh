#!/usr/bin/env bash

# Update and upgrade the system
sudo apt-get update
sudo apt-get upgrade -y

# Install necessary packages
sudo apt-get install -y openssh-server

# Ensure SSH service is enabled and started
sudo systemctl enable ssh
sudo systemctl start ssh

# Configure SSH to allow password authentication
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Restart SSH service to apply changes
sudo systemctl restart ssh

# Set the password for the ubuntu user
echo "ubuntu:breach" | sudo chpasswd

# Optional: Allow root login if needed (use with caution)
# sudo sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# sudo systemctl restart ssh

# Additional setup steps as needed