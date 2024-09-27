#!/bin/bash

if ! java -version &>/dev/null; then
    echo "Java not found. Installing OpenJDK..."
    echo "Install JDK"
    sudo wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo apt-key add -
    echo "deb https://packages.adoptium.net/artifactory/deb focal main" | sudo tee /etc/apt/sources.list.d/adoptium.list
    sudo apt update
    sudo apt install temurin-21-jdk -y
fi

sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure -f noninteractive unattended-upgrades

if ! command -v elastic-agent &>/dev/null; then
    echo "Installing Elastic Agent..."
    curl -L -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.15.2-amd64.deb
    sudo dpkg -i elastic-agent-8.15.2-amd64.deb
fi

echo "Setup completed successfully."
