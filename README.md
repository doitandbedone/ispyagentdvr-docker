# iSpy Agent DVR (Unofficial Image)
This is an unofficial docker image of agent dvr from ispy created for convenience. The software creates a local server for IP cameras to be managed. For more information visit:
https://www.ispyconnect.com/userguide-agent.aspx

## Recommended settings:
### Port:
By default the container will use port 8090 for Web UI. To access the panel go to http://localhost:8090 or replace localhost with your local IP.
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

## Example run:
```bash
docker run -it --net=host -p 8090:8090 \
-v /appdata/ispyagentdvr/config/:/agent/Media/XML/ \
-v /appdata/ispyagentdvr/media/:/agent/Media/WebServerRoot/Media/
```
## Known issues:
This image can only be run on host network due to WebRTC's random port selection. You will see a warning about the port and host network, left intentionally in command for informational purposes. Please email me if you find a workaround. Issue: 
https://github.com/doitandbedone/ispyagentdvr-docker/issues/1
