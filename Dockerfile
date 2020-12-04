# Use MS maintained .net docker image wuith aspnet and core runtimes.
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1.10-bionic

#Define download location variables
ARG FILE_LOCATION="https://ispyrtcdata.blob.core.windows.net/downloads/Agent_Linux64_H264.zip"
ENV FILE_LOCATION_SET=${FILE_LOCATION:+true}
ENV DEFAULT_FILE_LOCATION="https://www.ispyconnect.com/api/Agent/DownloadLocation2?productID=24&is64=true&platform=Linux"
ARG DEBIAN_FRONTEND=noninteractive 
ARG TZ=America/Los_Angeles
    

# Download and install dependencies
RUN apt-get update \
    && apt-get install -y make git wget build-essential software-properties-common libxml2 libtbb-dev unzip multiarch-support gss-ntlmssp \
    && wget http://security.ubuntu.com/ubuntu/pool/main/libj/libjpeg-turbo/libjpeg-turbo8_1.5.2-0ubuntu5.18.04.4_amd64.deb \
    && wget http://fr.archive.ubuntu.com/ubuntu/pool/main/libj/libjpeg8-empty/libjpeg8_8c-2ubuntu8_amd64.deb \
    && dpkg -i libjpeg-turbo8_1.5.2-0ubuntu5.18.04.4_amd64.deb \
    && dpkg -i libjpeg8_8c-2ubuntu8_amd64.deb \
    && rm libjpeg8_8c-2ubuntu8_amd64.deb \
    && rm libjpeg-turbo8_1.5.2-0ubuntu5.18.04.4_amd64.deb

# Prepare nvidia runtime
RUN curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | apt-key add - &&\
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) && \
curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | \
tee /etc/apt/sources.list.d/nvidia-container-runtime.list && \
apt-get update && apt-get install -y nvidia-container-runtime
  

# ffmpeg dependencies
RUN apt-get update -qq && apt-get -y install \
  autoconf \
  automake \
  build-essential \
  cmake \
  git-core \
  libass-dev \
  libfreetype6-dev \
  libgnutls28-dev \
  libsdl2-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  pkg-config \
  texinfo \
  yasm \
  zlib1g-dev
  
# ffmpeg ppa
RUN add-apt-repository ppa:jonathonf/ffmpeg-4 && \
apt-get update && apt-get install -y ffmpeg

# Download/Install Nvidia codec headers
RUN git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git && \
    cd nv-codec-headers && make install

# Download, compile and install ffmpeg with Nvidia hardware accelaration
RUN wget http://ffmpeg.org/releases/ffmpeg-4.3.1.tar.xz && \
    tar -xf ffmpeg-4.3.1.tar.xz && rm ffmpeg-4.3.1.tar.xz
RUN ls -la /usr/lib/x86_64-linux-gnu
RUN cd ffmpeg-4.3.1/ && \
    ./configure \
    --prefix=/usr --extra-version='0york0~18.04' --toolchain=hardened --libdir=/usr/lib/x86_64-linux-gnu \
    --incdir=/usr/include/x86_64-linux-gnu --arch=amd64 --enable-cuda --enable-cuvid --enable-nvenc && \
    --enable-gpl --disable-stripping --enable-avresample --disable-filter=resample --enable-gnutls --enable-ladspa \
    --enable-libaom --enable-libass --enable-libbluray \
    --enable-libbs2b --enable-libcaca --enable-libcdio --enable-libcodec2 --enable-libflite --enable-libfontconfig \
    --enable-libfreetype --enable-libfribidi --enable-libgme --enable-libgsm --enable-libjack --enable-libmp3lame \
    --enable-libmysofa --enable-libopenjpeg --enable-libopenmpt --enable-libopus --enable-libpulse --enable-librabbitmq \
    --enable-librsvg --enable-librubberband --enable-libshine --enable-libsnappy --enable-libsoxr --enable-libspeex \
    --enable-libsrt --enable-libssh --enable-libtheora --enable-libtwolame --enable-libvidstab --enable-libvorbis \
    --enable-libvpx --enable-libwebp --enable-libx265 --enable-libxml2 --enable-libxvid \
    --enable-libzmq --enable-libzvbi --enable-lv2 --enable-omx --enable-openal --enable-opencl --enable-opengl \
    --enable-sdl2 --enable-libzimg --enable-pocketsphinx --enable-libdc1394 --enable-libdrm --enable-libiec61883 \
    --enable-chromaprint --enable-frei0r --enable-libx264 --enable-shared --docdir=/usr/share/doc/ffmpeg-4.3.1 && \
    make && gcc tools/qt-faststart.c -o tools/qt-faststart

# Download/Install iSpy Agent DVR:
# Check if we were given a specific version
RUN if [ "${FILE_LOCATION_SET}" = "true" ]; then \
    echo "Downloading from specific location: ${FILE_LOCATION}" && \
    wget -c ${FILE_LOCATION} -O agent.zip; \
    else \
    #Get latest instead
    echo "Downloading latest" && \
    wget -c $(wget -qO- "https://www.ispyconnect.com/api/Agent/DownloadLocation2?productID=24&is64=true&platform=Linux" | tr -d '"') -O agent.zip; \
    fi && \
    unzip agent.zip -d /agent && \
    rm agent.zip
    
# Install libgdiplus, used for smart detection
RUN apt-get install -y libgdiplus
    
# Install Time Zone
RUN apt-get install -y tzdata

# Clean up
RUN apt-get -y --purge remove unzip wget \ 
    && apt autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Docker needs to run a TURN server to get webrtc traffic to and from it over forwarded ports from the host
# These are the default ports. If the ports below are modified here you'll also need to set the ports in XML/Config.xml
# for example <TurnServerPort>3478</TurnServerPort><TurnServerMinPort>50000</TurnServerMinPort><TurnServerMaxPort>50010</TurnServerMaxPort>
# The main server port is overridden by creating a text file called port.txt in the root directory containing the port number, eg: 8090
# To access the UI you must use the local IP address of the host, NOT localhost - for example http://192.168.1.12:8090/

# Define default environment variables
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Main UI port
EXPOSE 8090

# TURN server port
EXPOSE 3478/udp

# TURN server UDP port range
EXPOSE 50000-50010/udp

# Data volumes
VOLUME ["/agent/Media/XML", "/agent/Media/WebServerRoot/Media"]

# Define service entrypoint
CMD ["dotnet", "/agent/Agent.dll"]
