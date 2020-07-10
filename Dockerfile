FROM phusion/baseimage:0.11

LABEL maintainer="doitandbedone"

# Add universe repo
RUN add-apt-repository universe \
  && apt-get update \
  
  # Install wget
  && apt-get install -y wget \

  # Install .NET core:
  # Add MS repo key and feed
  && wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
  && dpkg -i packages-microsoft-prod.deb \

  # Install .NET Core SDK
  && apt-get install -y apt-transport-https \
  && apt-get update \
  && apt-get install -y dotnet-sdk-3.1 \

  # Install ASP .NET Core runtime
  && apt-get install -y apt-transport-https \
  && apt-get update \
  && apt-get install -y aspnetcore-runtime-3.1 \

  # Install .NET Core runtime
  && apt-get install -y apt-transport-https \
  && apt-get update \
  && apt-get install -y dotnet-runtime-3.1 \

  # Install FFmpeg v4.x:
  && add-apt-repository ppa:jonathonf/ffmpeg-4 \
  && apt-get update \
  && apt-get install -y ffmpeg \

  # Install libtbb and libc6 (Optional)
  && apt-get install -y libtbb-dev \
  && apt-get install -y libc6-dev \

  # Install unzip:
  && apt-get install -y unzip \

  # Download/Install iSpy Agent DVR (latest version):
  && wget -c $(wget -qO- "https://www.ispyconnect.com/api/Agent/DownloadLocation2?productID=24&is64=true&platform=Linux" | tr -d '"') -O agent.zip \
  && unzip agent.zip -d /agent \
  && rm agent.zip

# Main UI port
EXPOSE 8090

# Data volumes
VOLUME ["/agent/Media/XML", "/agent/Media/WebServerRoot/Media"]

# Define service entrypoint
ENTRYPOINT ["dotnet", "/agent/Agent.dll"]
