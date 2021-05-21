#!/bin/sh
echo $PUID:$PGID $USERNAME
echo $UID:$GID
groups
# Capture current user/group
UID=$(id -u) && GID=$(id -g) && echo $UID:$GID
ls -la /agent/Media/
#UID=$(id -u $USERNAME) && GID=$(id -g $USERNAME) 
# Will only be able to perform if user is root
if [ "$UID" = '0' ]; then
    # Check if desired user/group are available
    if [ -n "$PUID$PGID" ] ; then
        # Modify group and user to map to desired
        groupmod --gid $PGID ispyadmins
        usermod -u $PUID -g $PGID $USERNAME
    fi
    echo $(id -u $USERNAME) $(id -g $USERNAME)
    chown -R $PUID:$PGID /agent/*
    ls -la /agent/Media/
    exec gosu $USERNAME dotnet '/agent/Agent.dll'
else
    echo "To run this as non-root please run initially run the container as root and with -PUID -PGID parameters"
fi