# Use Ubuntu LTS
FROM ubuntu:22.04

# Define download location variables


ARG FILE_LOCATION="https://ispyfiles.azureedge.net/downloads/Agent_Linux64_6_2_7_0.zip"



ENV FILE_LOCATION_SET=${FILE_LOCATION:+true}
ENV DEFAULT_FILE_LOCATION="https://www.ispyconnect.com/api/Agent/DownloadLocation4?platform=Linux64&fromVersion=0"
ARG DEBIAN_FRONTEND=noninteractive 
ARG TZ=America/Los_Angeles
ARG name
    

# Download and install dependencies
RUN apt-get update \
    && apt-get install -y wget unzip software-properties-common alsa-utils apt-transport-https libxext-dev fontconfig libva-drm2

# Download/Install iSpy Agent DVR: 
# Check if we were given a specific version
RUN if [ "${FILE_LOCATION_SET}" = "true" ]; then \
    echo "Downloading from specific location: ${FILE_LOCATION}" && \
    wget -c ${FILE_LOCATION} -O agent.zip; \
    else \
    #Get latest instead
    echo "Downloading latest" && \
    wget -c $(wget -qO- "https://www.ispyconnect.com/api/Agent/DownloadLocation4?platform=Linux64&fromVersion=0" | tr -d '"') -O agent.zip; \
    fi && \
    unzip agent.zip -d /agent && \
    rm agent.zip
    
# Install libgdiplus, used for smart detection
RUN apt-get install -y libgdiplus

# Ensure the target ffmpeg directory exists
RUN mkdir -p /agent/ffmpeg7
# Download and extract the archive to the specified directory
RUN wget https://ispyrtcdata.blob.core.windows.net/downloads/ffmpeg7-linuxx64.tar.xz &&\
    tar -xvf ffmpeg7-linuxx64.tar.xz --strip-components=1 -C "/agent/ffmpeg7"

    
# Install Time Zone
RUN apt-get install -y tzdata

# Install curl, used for calling external webservices in Commands
RUN apt-get install -y curl

# Clean up
RUN apt-get -y --purge remove unzip wget build-essential \ 
    && apt autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Docker needs to run a TURN server to get webrtc traffic to and from it over forwarded ports from the host
# These are the default ports. If the ports below are modified here you'll also need to set the ports in XML/Config.xml
# for example <TurnServerPort>3478</TurnServerPort><TurnServerMinPort>50000</TurnServerMinPort><TurnServerMaxPort>50010</TurnServerMaxPort>
# The main server port is overridden by creating a text file called port.txt in the root directory containing the port number, eg: 8090
# To access the UI you must use the local IP address of the host, NOT localhost - for example http://192.168.1.12:8090/

# Modify permission for execution
RUN echo "Adding executable permissions" && \
    chmod +x /agent/Agent && \
    chmod +x /agent/agent-register.sh && \
    chmod +x /agent/agent-reset.sh && \
    chmod +x /agent/agent-reset-local-login.sh

# Define default environment variables
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# Fix a memory leak on encoded recording
ENV MALLOC_TRIM_THRESHOLD_=100000

# Main UI port
EXPOSE 8090

# STUN server port
EXPOSE 3478/udp

# TURN server UDP port range
EXPOSE 50000-50100/udp

# Data volumes
VOLUME ["/agent/Media/XML", "/agent/Media/WebServerRoot/Media", "/agent/Commands"]

# Define service entrypoint
CMD ["/agent/Agent"]
