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

# Download/Install iSpy Agent DVR:
RUN wget https://ispyfiles.azureedge.net/downloads/Agent_Linux64_2_7_5_0.zip && \
unzip Agent_Linux64_2_7_5_0.zip -d /agent && \
rm Agent_Linux64_2_7_5_0.zip

# Main UI port
EXPOSE 8090

# Data volumes
VOLUME ["/agent/Media/XML", "agent/Media/WebServerRoot/Media/audio", "agent/Media/WebServerRoot/Media/video"]

CMD dotnet /agent/Agent.dll