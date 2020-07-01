# iSpy Agent DVR (Unofficial Image)
This is an unofficial docker image of agent dvr from ispy created for convenience. The software creates a local server for IP cameras to be managed. For more information visit:
https://www.ispyconnect.com/userguide-agent.aspx

## Recommended settings:
### Port:
By default the container will use port 8090 for Web UI. To access the panel go to http://localhost:8090 or replace localhost with your local IP.
### Volumes:
#### Config: 
/agent/Media/XML/
#### Audio: 
/agent/Media/WebServerRoot/Media/audio/
#### Video: 
/agent/Media/WebServerRoot/Media/video/

## Example run:
```bash
docker run -it --net=host -p 8090:8090 \
-v /appdata/ispyagentdvr/config/:/agent/Media/XML/ \
-v /appdata/ispyagentdvr/audio/:/agent/Media/WebServerRoot/Media/audio/ \
-v /appdata/ispyagentdvr/video/:/agent/Media/WebServerRoot/Media/video/
```
## Known issues:
This image can only be run on host network due to WebRTC's random port selection. You will see a warning about the port and host network, left intentionally in command for informational purposes. Please email me if you find a workaround. Issue: 
https://github.com/doitandbedone/ispyagentdvr-docker/issues/1
