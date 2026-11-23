#!/usr/bin/env bash
set -euo pipefail
working_dir=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
temp_dir=$(mktemp -d)
trap 'rm -rf -- "$temp_dir"' EXIT

echo "==================="
echo "Defaults Installer v1"
echo "==================="
echo "Remember to have started Firefox first, at least once."
read -rp "Continue? [y/N] " reply
[[ $reply =~ ^[Yy]$ ]] || { echo "Battlefield offline";  exit 0; }
echo "Enter Authorization: "
sudo -v
echo "Establishing battlefield control, standby..."
sleep 1
echo "."
sleep 1
echo ".."
sleep 1
echo "..."

# ============================
# download packages
# ============================

sudo dnf install -y jq

curl -fL "https://vencord.dev/download/vesktop/amd64/rpm" -o $temp_dir/vesktop-latest.rpm
curl -f "https://api.github.com/repos/OpenTabletDriver/OpenTabletDriver/releases/latest" | jq -r '.assets[] | select(.name | endswith(".x86_64.rpm")) | .browser_download_url' | xargs curl -Lfo $temp_dir/opentabletdriver-latest.rpm
curl -fL "https://data.services.jetbrains.com/products/download?code=TBA&platform=linux" -o $temp_dir/jetbrains-toolbox-latest.tar.gz

# ============================
# install apps
# ============================

# Fedora packages setup
sudo dnf config-manager enable rpmfusion-nonfree-steam
sudo dnf config-manager enable rpmfusion-nonfree-nvidia-driver
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc && echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo dnf config-manager addrepo --from-repofile=https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

# Fedora packges install
sudo dnf install -y --refresh gimp krita audacity solaar gh fish kitty steam protontricks blender akmod-nvidia helix code sublime-text dotnet-runtime-10.0

# RPM package install
sudo dnf install -y $temp_dir/vesktop-latest.rpm
sudo dnf install -y $temp_dir/opentabletdriver-latest.rpm

# Flatpak install
sudo flatpak install -y io.github.Faugus.faugus-launcher md.obsidian.Obsidian org.polymc.PolyMC com.heroicgameslauncher.hgl

# Tarball install
sudo mkdir /opt/Jetbrains
sudo tar -xf $temp_dir/jetbrains-toolbox-latest.tar.gz -C /opt/Jetbrains

# Curl install
curl -fs https://ohmyposh.dev/install.sh | bash -s

# ============================
# configs
# ============================

# dotfiles
for dir in fish helix kitty; do
    rm -rf ~/.config/$dir;
    ln -s $working_dir/$dir ~/.config/$dir;
done

# nvidia drivers
sudo akmods --force

# firefox user chrome
profile=$(awk -F= '/^\[Install/{f=1} f&&/^Default=/{print $2; exit}' ~/.mozilla/firefox/profiles.ini)
ln -s $working_dir/firefox/chrome ~/.mozilla/firefox/$profile/chrome

# opentabletdriver
sudo dracut --regenerate-all --force
systemctl --user enable opentabletdriver.service --now

# fish
chsh -s "$(command -v fish)"

# ============================
# wrap up
# ============================
echo "Finish jetbrains toolbox installation with the following:"
echo "  /opt/Jetbrains/jetbrains-toolbox-<version>/bin/jetbrains-toolbox"
echo "---"
echo "Check for misplaced desktop entries in ~/.local/share/applications"
echo "They can be moved to /usr/share/applications"
echo "---"
echo "These are the widgets you used for desktop panels:"
echo "  Places"
echo "  Advanced Media Player"
echo "  Compact Pager"
echo "---"
echo "Enable css customization on Firefox:"
echo "  Open about:config"
echo "  Set toolkit.legacyUserProfileCustomizations.stylesheets to true"
