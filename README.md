# iSpy Agent DVR
This is a docker image for Agent DVR from iSpy created for convenience. Please consider donating/sponsoring. While still in direct contact with iSpy, we still maintain this at our own time.
The software creates a local server for IP cameras to be managed. For more information visit:
https://www.ispyconnect.com/userguide-agent-dvr.aspx

### Sponsorship/Donations:

|Ways to support us| |
|---|---|
|Github|Paypal|
[💗 Sponsor](https://github.com/sponsors/doitandbedone)|[![Paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/donate/?hosted_button_id=WE2AE6VBDVJBJ)|


## Recommended settings:
### Ports:
#### 8090: 
By default the container will use port 8090 for Web UI. To access the panel go to http://localhost:8090 or replace localhost with your local IP.

#### 3478
Main port used for TURN server communication.

#### 50000-50010
Ports used to create connections or WebRTC. These will be used as needed.

### Volumes:
#### Config: 
/agent/Media/XML/
#### Media: 
/agent/Media/WebServerRoot/Media/
#### Commands:
/agent/Commands

#### Migration Notes: If you had the old format of audio and video volumes please move them within the new media folder before starting the container again.
It would look something like this:
mkdir /appdata/ispyagentdvr/media
mv /apdata/ispyagentdvr/audio /appdata/ispyagentdvr/media
mv /appdata/ispyagentdvr/video /appdata/ispyagentdvr/media

## Running Image :
```bash
docker run -it -p 8090:8090 -p 3478:3478/udp -p 50000-50010:50000-50010/udp \
-v /appdata/ispyagentdvr/config/:/agent/Media/XML/ \
-v /appdata/ispyagentdvr/media/:/agent/Media/WebServerRoot/Media/ \
-v /appdata/ispyagentdvr/commands:/agent/Commands/ \
-e TZ=America/Los_Angeles \
--name ispyagentdvr doitandbedone/ispyagentdvr
```
This will default to the latest. See Tags section for other versions. Make sure to change TZ value to your own timezone, here's a table with all values:
https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

### Tags:
#### latest:
This tag will give you the latest version of the build.
```bash
docker run -it -p 8090:8090 -p 3478:3478/udp -p 50000-50010:50000-50010/udp \
-v /appdata/ispyagentdvr/config/:/agent/Media/XML/ \
-v /appdata/ispyagentdvr/media/:/agent/Media/WebServerRoot/Media/ \
-v /appdata/ispyagentdvr/commands:/agent/Commands/ \
-e TZ=America/Los_Angeles \
--name ispyagentdvr doitandbedone/ispyagentdvr:latest
```

#### Other versions:
Tags will also be created for older releases.
For example, for version 2.7.6.0:
```bash
docker run -it -p 8090:8090 -p 3478:3478/udp 50000-50010:50000-50010/udp \
-v /appdata/ispyagentdvr/config/:/agent/Media/XML/ \
-v /appdata/ispyagentdvr/media/:/agent/Media/WebServerRoot/Media/ \
-v /appdata/ispyagentdvr/commands:/agent/Commands/ \
-e TZ=America/Los_Angeles \
--name ispyagentdvr doitandbedone/ispyagentdvr:2.7.6.0
```

## Non host network use:
As of version 2.8.4.0 non host network is supported, for this to work, a turn server was included with the software. You will need to open up ports for this to porperly work, thus the UDP ports listed in the sample runs. 

To access UI panel go to the container's http://<container's ip>:<port> such as http://192.168.1.42:8090.
## VLC Support:
Please use tag vlc:
```bash
docker run -it -p 8090:8090 -p 3478:3478/udp -p 50000-50010:50000-50010/udp \
-v /appdata/ispyagentdvr/config/:/agent/Media/XML/ \
-v /appdata/ispyagentdvr/media/:/agent/Media/WebServerRoot/Media/ \
-v /appdata/ispyagentdvr/commands:/agent/Commands/ \
 -e TZ=America/Los_Angeles \
--name ispyagentdvr doitandbedone/ispyagentdvr:vlc
```

### Upgrade existing setup:
Open up a terminal, and let's call bash in your existing image:
```bash
docker exec -it ispyagentdvr /bin/bash
```
Once in, run the following command:
```bash
apt-get update && apt-get install -y libvlc-dev vlc libx11-dev
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
Also note if you remove the container you will have to do this again. Reason why we recommend using vlc tag instead.

### Feedback:
- [Ask a question](https://github.com/doitandbedone/ispyagentdvr-docker/discussions/146)
- [Report an issue](https://github.com/doitandbedone/ispyagentdvr-docker/issues/new?assignees=&labels=bug&template=bug_report.md)
- [Request a feature](https://github.com/doitandbedone/ispyagentdvr-docker/issues/new?assignees=&labels=enhancement&template=feature_request.md)
- [Join our discussions](https://github.com/doitandbedone/ispyagentdvr-docker/discussions)
 

