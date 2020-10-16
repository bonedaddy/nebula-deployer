#! /bin/bash

IS_ARM64=$(uname -a | grep -c -e arm64 -e aarch64)
IS_ARMV6=$(uname -a | grep -c -e armv6)
IS_ARMV7=$(uname -a | grep -c armv7)
VERSION="v1.3.0"
SHASUM_URL="https://github.com/slackhq/nebula/releases/download/${VERSION}/SHASUM256.txt"
INSTALL_DIR="/usr/bin"
DOWNLOAD_URL=""
TARNAME=""

if [[ "$IS_ARM64" -ge "1" ]]; then
    DOWNLOAD_URL="https://github.com/slackhq/nebula/releases/download/${VERSION}/nebula-linux-arm64.tar.gz"
    TARNAME="nebula-linux-arm64.tar.gz"
elif [[ "$IS_ARMV6" -ge "1" ]]; then
    DOWNLOAD_URL="https://github.com/slackhq/nebula/releases/download/${VERSION}/nebula-linux-arm-6.tar.gz"
    TARNAME="nebula-linux-arm-6.tar.gz"
elif [[ "$IS_ARMV7" -ge "1" ]]; then
    DOWNLOAD_URL="https://github.com/slackhq/nebula/releases/download/${VERSION}/nebula-linux-arm-7.tar.gz"
    TARNAME="nebula-linux-arm-7.tar.gz"
else
    DOWNLOAD_URL="https://github.com/slackhq/nebula/releases/download/${VERSION}/nebula-linux-amd64.tar.gz"
    TARNAME="nebula-linux-amd64.tar.gz"
fi

echo "download: $DOWNLOAD_URL"
echo "tarname: $TARNAME"

# download binaries
wget "$DOWNLOAD_URL"
# download sha checksums
wget "$SHASUM_URL"

WANT_SHA256_HASH=$(grep "$TARNAME" SHASUM256.txt | head -n 1 | awk '{print $1}')
HAVE_SHA256_HASH=$(sha256sum "$TARNAME" | awk '{print $1}')

if [[ "$WANT_SHA256_HASH" != "$HAVE_SHA256_HASH" ]]; then
    echo "[ERROR] sha256sum verification failed, bad download susepcted. exiting..."
    exit 1
fi

# untar binaries
tar zxvf "$TARNAME"

# copy binaries
sudo cp nebula nebula-cert "$INSTALL_DIR"

# remove source files
rm "$TARNAME" nebula nebula-cert SHASUM256.txt

# create system user
sudo useradd -m nebula 2>&1 | tee /dev/null
# change usershell
sudo usermod --shell /bin/false nebula

# create config file directory
sudo mkdir /etc/nebula

# adjust group ownership of config file directory
sudo chown -R nebula:nebula /etc/nebula
