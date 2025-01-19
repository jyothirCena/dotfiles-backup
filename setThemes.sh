#!/bin/bash

# Update and upgrade the system
echo "Updating and upgrading system packages..."
sudo apt update && sudo apt upgrade -y

# Install required packages
echo "Installing required packages..."
sudo apt install -y git tar curl gnome-tweaks gnome-shell-extensions gnome-shell-extension-manager

# Start the script in home
cd ~

# Clone the WhiteSur theme repository
echo "Cloning the WhiteSur GTK theme repository..."
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git

# Run the theme installation script
echo "Installing the WhiteSur GTK theme..."
~/WhiteSur-gtk-theme/install.sh -l -m -N stable --round

# Move the WhiteSur-Dark theme to the global themes directory
echo "Moving WhiteSur-Dark theme to /usr/share/themes..."
sudo mv ~/.themes/WhiteSur-Dark /usr/share/themes

# Remove .themes folder to clean up
echo "Cleaning up the ~/.themes folder..."
rm -rf ~/.themes

# Wait 2 seconds
sleep 2

# Download the macOS cursor tarball
echo "Downloading the macOS cursor tarball..."
curl -O https://raw.githubusercontent.com/jyothirCena/assets/refs/heads/main/macOS.tar.gz

# Unzip the tarball into /usr/share/icons
echo "Extracting and moving the macOS cursor theme to /usr/share/icons..."
tar -xzf macOS.tar.gz

# Move macOS folders to /usr/share/icons
sudo cp -r ~/macOS/* /usr/share/icons

# Cleanup stuff related to macOS-cursor theme
echo "macOS cursor theme clean up"
rm macOS.tar.gz
rm -r ~/macOS

# Wait 2 seconds
sleep 2

# Download the Cupertino-Sonoma icon pack repository
echo "Cloning the Cupertino-Sonoma icon pack repository..."
curl -O https://raw.githubusercontent.com/jyothirCena/assets/refs/heads/main/Cupertino-Sonoma.tar.xz

# Unzip the tarball
echo "Extracting and moving the Cupertino-Sonoma icon pack to /usr/share/icons..."
tar -xf Cupertino-Sonoma.tar.xz

# Move the Cupertino-Sonoma icon pack folder to /usr/share/icons
sudo mv Cupertino-Sonoma /usr/share/icons
rm Cupertino-Sonoma.tar.xz

# Wait 2 seconds
sleep 2

# Install and enable the User Themes extension
echo "Installing the User Themes extension..."

# Define variables
EXTENSION_UUID="user-theme@gnome-shell-extensions.gcampax.github.com"

# Installing the extension
echo "Installing the User Themes extension..."
gdbus call --session --dest org.gnome.Shell.Extensions --object-path /org/gnome/Shell/Extensions --method org.gnome.Shell.Extensions.InstallRemoteExtension 'user-theme@gnome-shell-extensions.gcampax.github.com'

# Waiting for user confirmation
echo "Waiting for user to confirm the extension installation in GNOME Shell..."
while true; do
    # Check if the extension is installed and enabled
    EXTENSION_STATUS=$(gnome-extensions info ${EXTENSION_UUID} | grep Enabled | awk '{print $2}')
    
    # If the extension is enabled (meaning it was installed and confirmed), break out of loop
    if [ "$EXTENSION_STATUS" = "Yes" ]; then
        echo "Extension '$EXTENSION_UUID' is confirmed as installed and enabled."
        break
    fi

    # Wait for a short duration before checking again
    sleep 5
done

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

# Center new windows
echo "Enable to open windows centered by default..."
gsettings set org.gnome.mutter center-new-windows true

# Modify dash to dock extension
echo "Modify dock appearance..."
gsettings set org.gnome.shell.extensions.dash-to-dock application-counter-overrides-notifications false
gsettings set org.gnome.shell.extensions.dash-to-dock autohide-in-fullscreen true
gsettings set org.gnome.shell.extensions.dash-to-dock click-action "focus-minimize-or-previews"
gsettings set org.gnome.shell.extensions.dash-to-dock customize-alphas true
gsettings set org.gnome.shell.extensions.dash-to-dock dance-urgent-applications false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position "BOTTOM"
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock require-pressure-to-show false
gsettings set org.gnome.shell.extensions.dash-to-dock show-dock-urgent-notify false
gsettings set org.gnome.shell.extensions.dash-to-dock show-icons-emblems false
gsettings set org.gnome.shell.extensions.dash-to-dock show-icons-notifications-counter false
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts-network false
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts-only-mounted true
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode "DYNAMIC"

echo "Installation completed successfully!"
