#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	gst-plugins-bad  \
	gst-plugins-base \
	gst-plugins-good \
	gst-libav        \
	pipewire-audio   \
	pipewire-jack    \
	qt5ct            \
	qt5-wayland

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
wget --retry-connrefused --tries=30 "$EXTRA_PACKAGES" -O ./get-debloated-pkgs.sh
chmod +x ./get-debloated-pkgs.sh
get-debloated-pkgs --add-opengl --prefer-nano ffmpeg-mini libxml2-mini icu-mini

# Comment this out if you need an AUR package
make-aur-package clementine

# If the application needs to be manually built that has to be done down here
