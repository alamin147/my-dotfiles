curl -s "https://get.sdkman.io" | bash

#inside >bashrc/zshrc
# add to end of file
source "$HOME/.sdkman/bin/sdkman-init.sh"

#install
sdk install java 11.0.20-tem

#version
java -version
