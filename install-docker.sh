#!/bin/bash

# Detect the operating system
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    echo "Installing Docker on macOS..."
    # You can install Docker for macOS using Homebrew
    # Make sure Homebrew is installed first
    if ! command -v brew &>/dev/null; then
        echo "Homebrew is not installed. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    # Install Docker
    brew install docker
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Ubuntu (and other Linux distributions)
    echo "Installing Docker on Ubuntu..."
    # Update package list and install dependencies
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    # Add Docker repository
    echo "deb [signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    # Install Docker
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
fi

# Start the Docker service
sudo systemctl start docker

# Check Docker version
docker --version

# Add your user to the Docker group to run Docker commands without sudo (Linux only)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo usermod -aG docker $USER
    echo "You need to log out and log back in for the group changes to take effect."
fi

echo "Docker installation completed."
