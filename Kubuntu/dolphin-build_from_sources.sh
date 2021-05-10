# for finding dependencies, use cmake errors, apt search and google, don't use kdesrc-build as it's too bloated
# for all kde external dependencies (not only dolphin), sudo apt install $(cat /path/to/externalDependencies.txt)

sudo apt install cmake extra-cmake-modules gettext qtbase5-dev kinit-dev libkf5doctools-dev libkf5kcmutils-dev libkf5newstuff-dev libkf5coreaddons-dev libkf5i18n-dev libkf5dbusaddons-dev libkf5bookmarks-dev libkf5config-dev libkf5kio-dev libkf5parts-dev libkf5solid-dev libkf5iconthemes-dev libkf5completion-dev libkf5textwidgets-dev libkf5notifications-dev libkf5crash-dev libkf5windowsystem-dev libphonon4qt5-dev
rm -rf ~/dolphin
mkdir ~/dolphin
cd ~/dolphin
mkdir git_repo
git clone --branch Kubuntu21.04_GGSK https://invent.kde.org/shafinkhadem/dolphin.git git_repo
mkdir install build
cd build
cmake -DCMAKE_INSTALL_PREFIX=~/dolphin/install -DCMAKE_BUILD_TYPE=Release ../git_repo
make && make install && ~/dolphin/install/bin/dolphin
