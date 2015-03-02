# Debian/Ubuntu 
set -e # exit on failure
sudo apt-get update
sudo apt-get install -y make g++ git mercurial autotools-dev automake libtool zlib1g-dev libbz2-dev libboost-all-dev libxmlrpc-core-c3-dev libxmlrpc-c3-dev
sudo locale-gen cy_GB.UTF-8 en_US.UTF-8
sudo dpkg-reconfigure locales

cd $HOME
git clone https://git.techiaith.bangor.ac.uk/cyfieithu/moses-smt.git

cd $HOME/moses-smt
./get/install-moses-smt.sh

