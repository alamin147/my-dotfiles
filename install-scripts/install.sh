sudo dnf install stow -y

sudo dnf install alacritty
sudo dnf install neovim

# starship
curl -sS https://starship.rs/install.sh | sh
sudo dnf install zoxide

sudo dnf install tmux
yazi #install with suggesstion
sudo dnf install wlsunset

#auto cpu freq
cd
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer
sudo auto-cpufreq --install
#sudo auto-cpufreq --remove # to remove

#from commands
# ./fun-tools.sh

sudo npm install --global yarn
    sudo dnf copr enable atim/lazygit -y
    sudo dnf install lazygit
