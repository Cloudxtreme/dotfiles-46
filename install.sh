#!/bin/sh

CURDIR=$(pwd)

# create symlinks
for file in .bashrc .brew .gitconfig .ssh/assh.yml .zshrc Library/Preferences/com.apple.Terminal.plist Vagrantfile virtualenvwrapper; do
    (
        if [ -e "${HOME}/${file}" ]; then
            echo "- ln -s ${CURDIR}/${file} ${HOME}/${file}: file exists"
        else
            (
                set -x
                ln -s "${CURDIR}/${file}" "${HOME}/${file}"
            )
        fi
    )
done

# configure osx prefs
echo "You can configure OS X preferences using the following command:"
echo "   bash -x ./.osx-prefs"
