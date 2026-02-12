#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q clementine | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export ADD_HOOKS="self-updater.bg.hook"
export OUTPATH=./dist
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export DESKTOP=/usr/share/applications/org.clementine_player.Clementine.desktop
export ICON=/usr/share/icons/hicolor/128x128/apps/org.clementine_player.Clementine.png
export DEPLOY_OPENGL=1
export DEPLOY_PIPEWIRE=1
export DEPLOY_GSTREAMER=1

# Deploy dependencies
quick-sharun /usr/bin/clementine*

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --test ./dist/*.AppImage
