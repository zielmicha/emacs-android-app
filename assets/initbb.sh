export SDCARD=/mnt/sdcard
export EHOME=$SDCARD/emacs
export HOME=$EHOME
export PRIVATE=$(./busybox pwd)
export PATH=$PRIVATE:$PATH
export BB=busybox

if [ ! -d $EHOME ]; then
    mkdir $EHOME
fi

if [ ! -e $EHOME/busyboxrc.sh ]; then
    echo "Emacs for Android"
    echo
    echo "Ported by Michal Zielinski (zielmicha) http://zielm.com"
    echo "This is free software - you can grab source at"
    echo "https://github.com/zielmicha/emacs-android"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "Emacs                               Copyright (C) Free Software Foundation, Inc."
    echo "Terminal Emulator                   Copyright (C) Jack Palevich"
    echo "Terminal/Emacs modifications        Copyright (C) Michal Zielinski (zielmicha)"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo ""
    echo "Emacs needs to download itself from the Internet (~22MB)."
    echo ""
    echo " y - continue "
    echo " n - abort"
    echo " m - choose mirror"
    echo ""
    while [ "$choice" != y -a "$choice" != n -a "$choice" != m ]; do
        echo -n "Your choice: "
        read -n 1 choice
        echo
    done

    if [ "$choice" = n ]; then
        exit 1
    fi

    MIRROR=http://emacs.zielm.com/data
    if [ "$choice" = m ]; then
        echo -n "Mirror URL: "
        read MIRROR
    fi
    echo
    echo "Using mirror $MIRROR"
    echo
    busybox wget $MIRROR/busyboxrc.sh -O $EHOME/busyboxrc.sh.dl || (
        echo "Download failed. Press Enter to exit."
        read
        exit 1)
    mv $EHOME/busyboxrc.sh.dl $EHOME/busyboxrc.sh
    echo
    echo "Chaining to downloaded installer."
fi

exec busybox sh $EHOME/busyboxrc.sh

echo
echo Something went wrong.
echo You can report error to emacs@zielm.com.
echo
echo Dropping to shell.
./busybox sh
