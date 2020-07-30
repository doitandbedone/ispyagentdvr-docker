# Use MS maintained .net docker image wuith aspnet and core runtimes.  SDK does not seem to be needed. This saves space on mulitple levels.
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1

# Removed label, as deprected. Removed universe repo and .net install as no needed.

# Collpased operations to reduce layer overhead and better apt clean up.

RUN apt-get update \
    && apt-get install -y wget ffmpeg libtbb-dev libc6-dev unzip multiarch-support gss-ntlmssp\
    && wget http://security.ubuntu.com/ubuntu/pool/main/libj/libjpeg-turbo/libjpeg-turbo8_1.5.2-0ubuntu5.18.04.4_amd64.deb \
    && wget http://fr.archive.ubuntu.com/ubuntu/pool/main/libj/libjpeg8-empty/libjpeg8_8c-2ubuntu8_amd64.deb \
    && dpkg -i libjpeg-turbo8_1.5.2-0ubuntu5.18.04.4_amd64.deb \
    && dpkg -i libjpeg8_8c-2ubuntu8_amd64.deb \
    && rm libjpeg8_8c-2ubuntu8_amd64.deb \
    && rm libjpeg-turbo8_1.5.2-0ubuntu5.18.04.4_amd64.deb \
    && wget -c $(wget -qO- "https://www.ispyconnect.com/api/Agent/DownloadLocation2?productID=24&is64=true&platform=Linux" | tr -d '"') -O agent.zip \
    && unzip agent.zip -d /agent \
    && rm agent.zip \
    && apt-get -y --purge remove unzip wget \ 
    && apt autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

# Docker needs to run a TURN server to get webrtc traffic to and from it over forwarded ports from the host
# These are the default ports. If the ports below are modified here you'll also need to set the ports in XML/Config.xml
# for example <TurnServerPort>3478</TurnServerPort><TurnServerMinPort>50000</TurnServerMinPort><TurnServerMaxPort>50010</TurnServerMaxPort>
# The main server port is overridden by creating a text file called port.txt in the root directory containing the port number, eg: 8090
# To access the UI you must use the local IP address of the host, NOT localhost - for example http://192.168.1.12:8090/

# added env vars, just good practice
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LANG C.UTF-8
ENV TZ America/Los_Angeles

# Main UI port
EXPOSE 8090

# TURN server port
EXPOSE 3478/udp

# TURN server UDP port range
EXPOSE 50000-50010/udp

# Data volumes
VOLUME ["/agent/Media/XML", "/agent/Media/WebServerRoot/Media"]

# changed to CMD for more flexibility and ad recommended by docker, suspersedes entrypoint, make it easier to launch with shell for troubleshoting - espeically when usingh docker platofrms with UI like synology or portainer.
CMD ["dotnet", "/agent/Agent.dll"]
