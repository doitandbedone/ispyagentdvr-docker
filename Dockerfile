FROM phusion/baseimage:0.11

LABEL maintainer="doitandbedone"

# Add universe repo
RUN add-apt-repository universe && \
apt-get update

# Install wget
RUN apt-get install -y wget

# Install .NET core:
# Add MS repo key and feed
RUN wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
dpkg -i packages-microsoft-prod.deb

# Install .NET Core SDK
RUN apt-get install -y apt-transport-https && \
apt-get update && \
apt-get install -y dotnet-sdk-3.1

# Install ASP .NET Core runtime
RUN apt-get install -y apt-transport-https && \
apt-get update && \
apt-get install -y aspnetcore-runtime-3.1

# Install .NET Core runtime
RUN apt-get install -y apt-transport-https && \
apt-get update && \
apt-get install -y dotnet-runtime-3.1

# Install FFmpeg v4.x:
RUN add-apt-repository ppa:jonathonf/ffmpeg-4 && \
apt-get update && \
apt-get install -y ffmpeg

# Install libtbb and libc6 (Optional)
RUN apt-get install -y libtbb-dev && \
apt-get install -y libc6-dev

# Install unzip:
RUN apt-get install -y unzip

# Download/Install iSpy Agent DVR (latest version):
RUN wget -c $(wget -qO- "https://www.ispyconnect.com/api/Agent/DownloadLocation2?productID=24&is64=true&platform=Linux" | tr -d '"') -O agent.zip && \
unzip agent.zip -d /agent && \
rm agent.zip

# Docker needs to run a TURN server to get webrtc traffic to and from it over forwarded ports from the host
# These are the default ports. If the ports below are modified here you'll also need to set the ports in XML/Config.xml
# for example <TurnServerPort>3478</TurnServerPort><TurnServerMinPort>50000</TurnServerMinPort><TurnServerMaxPort>50010</TurnServerMaxPort>
# The main server port is overridden by creating a text file called port.txt in the root directory containing the port number, eg: 8090
# To access the UI you must use the local IP address of the host, NOT localhost - for example http://192.168.1.12:8090/

# Main UI port
EXPOSE 8090

# TURN server port
EXPOSE 3478/udp

# TURN server UDP port range
EXPOSE 50000-50010/udp

# Data volumes
VOLUME ["/agent/Media/XML", "/agent/Media/WebServerRoot/Media"]

# Define service entrypoint
ENTRYPOINT ["dotnet", "/agent/Agent.dll"]
