#!/bin/sh

set -eux

ARCH="$(uname -m)"
EXTRA_PACKAGES="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/get-debloated-pkgs.sh"

pacman -Syu --noconfirm \
	base-devel       \
	curl             \
	git              \
	gst-plugins-bad  \
	gst-plugins-base \
	gst-plugins-good \
	libxcb           \
	libxcursor       \
	libxi            \
	libxkbcommon     \
	libxkbcommon-x11 \
	libxrandr        \
	libxtst          \
	pipewire-audio   \
	pulseaudio       \
	pulseaudio-alsa  \
	qt5ct            \
	qt5-wayland      \
	wget             \
	xorg-server-xvfb \
	zsync

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
wget --retry-connrefused --tries=30 "$EXTRA_PACKAGES" -O ./get-debloated-pkgs.sh
chmod +x ./get-debloated-pkgs.sh
./get-debloated-pkgs.sh --add-opengl --prefer-nano libxml2-mini opus-mini

echo "Building clementine..."
echo "---------------------------------------------------------------"
sed -i -e 's|EUID == 0|EUID == 69|g' /usr/bin/makepkg
sed -i -e 's|MAKEFLAGS=.*|MAKEFLAGS="-j$(nproc)"|; s|#MAKEFLAGS|MAKEFLAGS|' /etc/makepkg.conf
git clone https://aur.archlinux.org/clementine.git ./clementine
cd ./clementine
sed -i -e "s|x86_64|$ARCH|" ./PKGBUILD
makepkg -fs --noconfirm
ls -la .
pacman --noconfirm -U ./*.pkg.tar.*

pacman -Q clementine | awk '{print $2; exit}' > ~/version
