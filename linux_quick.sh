#!/bin/bash

# Function to install Git
install_git() {
    echo "Git is not installed. Installing Git..."
    sudo apt update
    sudo apt install -y git
}

# Function to install Python
install_python() {
    echo "Python is not installed. Installing Python..."
    sudo apt update
    sudo apt install -y python3 python3-venv python3-pip
}

# Function to install pip
install_pip() {
    echo "Pip is not installed. Installing Pip..."
    sudo apt update
    sudo apt install -y python3-pip
}

# Check if Git is installed
if ! command -v git &> /dev/null; then
    install_git
fi

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    install_python
fi

# Check if pip is installed
if ! command -v pip3 &> /dev/null; then
    install_pip
fi

# Clone the repository
git clone https://github.com/PixifyAI/insta-flux
if [ $? -ne 0 ]; then
    echo "Error: Failed to clone the repository."
    exit 1
fi

# Navigate to the project directory
cd insta-flux || exit 1

# Create a virtual environment
python3 -m venv venv
if [ $? -ne 0 ]; then
    echo "Error: Failed to create a virtual environment."
    exit 1
fi

# Activate the virtual environment
source venv/bin/activate
if [ $? -ne 0 ]; then
    echo "Error: Failed to activate the virtual environment."
    exit 1
fi

# Install the required packages
pip install -r requirements.txt
if [ $? -ne 0 ]; then
    echo "Error: Failed to install required packages."
    exit 1
fi

# Pause to remind the user to add their Runware API key
echo "Please add your Runware API key to the InstaFlux.py file."
read -p "Press [Enter] key to continue..."

# Run the script
python InstaFlux.py
if [ $? -ne 0 ]; then
    echo "Error: Failed to run the application."
    exit 1
fi

# Print success message
echo "Installation and execution completed successfully."
