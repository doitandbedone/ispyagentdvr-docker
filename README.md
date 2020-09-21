# iSpy Agent DVR (Unofficial Image)
This is an unofficial docker image of agent dvr from ispy created for convenience. The software creates a local server for IP cameras to be managed. For more information visit:
https://www.ispyconnect.com/userguide-agent-dvr.aspx

## Recommended settings:
### Ports:
#### 8090: 
By default the container will use port 8090 for Web UI. To access the panel go to http://localhost:8090 or replace localhost with your local IP.

#### 3478
Main port used for turn server communication.

#### 50000-50010
Ports used to create connections or WebRTC. These will be used as needed.

### Volumes:
#### Config: 
/agent/Media/XML/
#### Media: 
/agent/Media/WebServerRoot/Media/

#### Migration Notes: If you had the old format of audio and video volumes please move them within the new media folder before starting the container again.
It would look something like this:
mkdir /appdata/ispyagentdvr/media
mv /apdata/ispyagentdvr/audio /appdata/ispyagentdvr/media
mv /appdata/ispyagentdvr/video /appdata/ispyagentdvr/media

## Running Image :
```bash
docker run -it --net=host -p 8090:8090 -p 3478:3478/udp -p 50000-50010:50000-50010/udp \
-v /appdata/ispyagentdvr/config/:/agent/Media/XML/ \
-v /appdata/ispyagentdvr/media/:/agent/Media/WebServerRoot/Media/ \
--name ispyagentdvr doitandbedone/ispyagentdvr
```
This will default to the latest. See Tags section for other versions.

### Tags:
#### latest:
This tag will give you the latest version of the build.
```bash
docker run -it --net=host -p 8090:8090 -p 3478:3478/udp -p 50000-50010:50000-50010/udp \
-v /appdata/ispyagentdvr/config/:/agent/Media/XML/ \
-v /appdata/ispyagentdvr/media/:/agent/Media/WebServerRoot/Media/ \
--name ispyagentdvr doitandbedone/ispyagentdvr:latest
```

#### lite:
This will also give you a slighty smaller version of the latest build. This is under testing as it may remove some dependencies that may not be needed. If you encounter an issue, try a non lite version and see if there's any difference, otherwise, please report the issue.
```bash
docker run -it --net=host -p 8090:8090 -p 3478:3478/udp -p 50000-50010:50000-50010/udp \
-v /appdata/ispyagentdvr/config/:/agent/Media/XML/ \
-v /appdata/ispyagentdvr/media/:/agent/Media/WebServerRoot/Media/ \
--name ispyagentdvr doitandbedone/ispyagentdvr:lite
```

#### Other versions:
Tags will also be created for older releases.
For example, for version 2.7.6.0:
```bash
docker run -it --net=host -p 8090:8090 -p 3478:3478/udp 50000-50010:50000-50010/udp \
-v /appdata/ispyagentdvr/config/:/agent/Media/XML/ \
-v /appdata/ispyagentdvr/media/:/agent/Media/WebServerRoot/Media/ \
--name ispyagentdvr doitandbedone/ispyagentdvr:2.7.6.0
```

## Non host network use:
As of version 2.8.4.0 non host network is supported, for this to work, a turn server was included with the software. You will need to open up ports for this to porperly work, thus the UDP ports listed in the sample runs. 

To access UI panel go to the container's http://<container's ip>:<port> such as http://192.168.1.42:8090.
  
## VLC Support:
To enable VLC support, the following packages need to be installed:
- libvlc-dev
- vlc
- libx11-dev

### First time installation:
```bash
docker run -it --net=host -p 8090:8090 -p 3478:3478/udp -p 50000-50010:50000-50010/udp \
-v /appdata/ispyagentdvr/config/:/agent/Media/XML/ \
-v /appdata/ispyagentdvr/media/:/agent/Media/WebServerRoot/Media/ \
--name ispyagentdvr doitandbedone/ispyagentdvr:latest /bin/bash -c "apt-get install -y libvlc-dev vlc libx11-dev && dotnet /agent/Agent.dll"
```

### Upgrade existing setup:
Open up a terminal, and let's call bash in your existing image:
```bash
docker exec -it ispyagentdvr /bin/bash
```
Once in, run the following command:
```bash
apt-get install -y libvlc-dev vlc libx11-dev
```
Once the installation is done, exit out of bash:
```bash
exit
```
Now, let's restart the container:
```bash
docker restart ispyagentdvr
```
That should be it!

Please note that if you named your container differently you must use either the container id or name you assigned instead of "ispyagentdvr". You can get a list of containers by running the follwoing command:
```bash
docker ps -a
```


