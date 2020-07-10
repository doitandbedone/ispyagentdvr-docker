FROM phusion/baseimage:0.11

LABEL maintainer="doitandbedone"

  # Add universe repo
RUN add-apt-repository universe \

  # Install FFmpeg v4.x:
  && add-apt-repository ppa:jonathonf/ffmpeg-4 \
  && apt-get update \
  
  # Install wget
  && apt-get install -y wget \

  # Install .NET Core SDK
  && apt-transport-https \
  && dotnet-sdk-3.1 \

  # Install ASP .NET Core runtime
  && aspnetcore-runtime-3.1 \

  # Install .NET Core runtime
  && dotnet-runtime-3.1 \
  && ffmpeg \

  # Install libtbb and libc6 (Optional)
  && libtbb-dev \
  && libc6-dev \

  # Install unzip:
  && unzip \

  # Install .NET core:
  # Add MS repo key and feed
  && wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
  && dpkg -i packages-microsoft-prod.deb \
  
  # Download/Install iSpy Agent DVR (latest version):
  && wget -c $(wget -qO- "https://www.ispyconnect.com/api/Agent/DownloadLocation2?productID=24&is64=true&platform=Linux" | tr -d '"') -O agent.zip \
  && unzip agent.zip -d /agent \
  && rm agent.zip \
  && rm -rf /var/lib/apt/lists/*

# Main UI port
EXPOSE 8090

# Data volumes
VOLUME ["/agent/Media/XML", "/agent/Media/WebServerRoot/Media"]

# Define service entrypoint
ENTRYPOINT ["dotnet", "/agent/Agent.dll"]
