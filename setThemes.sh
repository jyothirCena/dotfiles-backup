#!/bin/bash

# Update and upgrade the system
echo "Updating and upgrading system packages..."
sudo apt update && sudo apt upgrade -y

# Install required packages
echo "Installing required packages..."
sudo apt install -y git curl gnome-tweaks gnome-shell-extension-manager tar

# Clone the WhiteSur theme repository
echo "Cloning the WhiteSur GTK theme repository..."
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git

# Change directory to the cloned repository
echo "Entering the cloned WhiteSur GTK theme directory..."
cd WhiteSur-gtk-theme

# Run the theme installation script
echo "Installing the WhiteSur GTK theme..."
./install.sh -l -m -N stable --round

# Move into the themes directory
echo "Changing to the ~/.themes directory..."
cd ~/.themes

# Move the WhiteSur-Dark theme to the global themes directory
echo "Moving WhiteSur-Dark theme to /usr/share/themes..."
sudo mv WhiteSur-Dark /usr/share/themes

# Remove .themes folder to clean up
echo "Cleaning up the ~/.themes folder..."
rm -rf ~/.themes

# Download the macOS cursor tarball
echo "Downloading the macOS cursor tarball..."
curl -L -o macOS.tar.xz https://github.com/ful1e5/apple_cursor/releases/download/v2.0.1/macOS.tar.xz

# Unzip the tarball into /usr/share/icons
echo "Extracting and moving the macOS cursor theme to /usr/share/icons..."
mkdir ~/macOS
tar -xf macOS.tar.xz -C ~/macOS

# Move only 'macOS' folder to /usr/share/icons
sudo mv ~/macOS/macOS /usr/share/icons

# Cleanup stuff related to macOS-cursor theme
echo "Cleaning up..."
rm macOS.tar.xz
rm -r ~/macOS

# Clone the Cupertino-Sonoma icon pack repository
echo "Cloning the Cupertino-Sonoma icon pack repository..."
git clone https://github.com/USBA/Cupertino-Sonoma-iCons.git

# Rename the folder
echo "Renaming the Cupertino-Sonoma icon pack folder..."
mv Cupertino-Sonoma-iCons Cupertino-Sonoma

# Move the renamed folder to /usr/share/icons
echo "Moving the Cupertino-Sonoma icon pack to /usr/share/icons..."
sudo mv Cupertino-Sonoma /usr/share/icons

# Install and enable the User Themes extension
echo "Installing the User Themes extension..."

# Define variables
EXTENSION_UUID="user-theme@gnome-shell-extensions.gcampax.github.com"
EXTENSION_URL="https://extensions.gnome.org/extension-data/user-themegnome-shell-extensions.gcampax.github.com.v44.shell-extension.zip"

# Create extensions directory if not present
mkdir -p ~/.local/share/gnome-shell/extensions

# Download the extension
echo "Downloading the User Themes extension..."
curl -o "${EXTENSION_UUID}.zip" "$EXTENSION_URL"

# Extract the extension to the correct directory
echo "Installing the User Themes extension..."
unzip -o "${EXTENSION_UUID}.zip" -d ~/.local/share/gnome-shell/extensions/"${EXTENSION_UUID}"

# Enable the extension
echo "Enabling the User Themes extension..."
gnome-extensions enable "${EXTENSION_UUID}"

# Clean up
echo "Cleaning up downloaded files..."
rm -f "${EXTENSION_UUID}.zip"

echo "Enabling the User Themes extension..."
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com

# Set the GTK theme
echo "Setting the GTK theme to WhiteSur-Dark..."
gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark"

# Set the GNOME Shell theme
echo "Setting the GNOME Shell theme to WhiteSur-Dark..."
gsettings set org.gnome.shell.extensions.user-theme name "WhiteSur-Dark"

# Set the icon theme
echo "Setting the icon theme to Cupertino-Sonoma..."
gsettings set org.gnome.desktop.interface icon-theme "Cupertino-Sonoma"

# Set the cursor theme
echo "Setting the cursor theme to macOS..."
gsettings set org.gnome.desktop.interface cursor-theme "macOS"

echo "Installation completed successfully!"
