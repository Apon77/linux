# docker build -t buildbot .
# docker run -it --name build --hostname \"aditya'sbuildbot\" -v '/mnt/baracuda/src/aospa:/src' -v '/home/coolboy/tmp/ccache2:/tmp/ccache' --rm buildbot:latest

FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
ENV USER docker 
ENV HOSTNAME buildbot
ENV USE_CCACHE 1
ENV LC_ALL C
ENV CCACHE_COMPRESS 1
ENV CCACHE_SIZE 50G
ENV CCACHE_DIR /tmp/ccache
ENV CCACHE_EXEC /usr/bin/ccache 
ENV USE_CCACHE true

# Install required dependencies 
RUN set -x \
    && apt-get -yqq update \
    && apt-get install --no-install-recommends -yqq \
        adb autoconf automake axel bc bison build-essential ccache clang cmake curl expat flex g++ g++-multilib gawk gcc gcc-multilib git git-core git-lfs gnupg gperf htop imagemagick kmod lib32ncurses5-dev lib32readline-dev lib32z1-dev libc6-dev libcap-dev libexpat1-dev libgmp-dev liblz4-* liblz4-tool liblzma* libmpc-dev libmpfr-dev libncurses5-dev libsdl1.2-dev libssl-dev libtinfo5 libtool libwxgtk3.0-dev libxml-simple-perl libxml2 libxml2-utils lzip lzma* lzop maven ncftp ncurses-dev patch patchelf pkg-config pngcrush pngquant python python-all-dev re2c rsync schedtool squashfs-tools subversion sudo texinfo unzip w3m xsltproc zip zlib1g-dev zram-config && \
    apt-get clean

# Install repo
RUN set -x \
    && curl --create-dirs -L -o /usr/local/bin/repo -O -L https://storage.googleapis.com/git-repo-downloads/repo \
    && chmod a+x /usr/local/bin/repo

# Create seperate build user
RUN groupadd -g 1000 -r ${USER} && \
    useradd -u 1000 --create-home -r -g ${USER} ${USER} && \
    mkdir -p /tmp/ccache /src && \
    chown -R ${USER}: /tmp/ccache /src

# Allow sudo without password for build user
RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-docker-build && \
    usermod -aG sudo ${USER}

# Setup volumes for persistent data
USER ${USER}
VOLUME ["/tmp/ccache", "/src"]

# Create gitconfig for build user
RUN git config --global user.name ${USER} && git config --global user.email ${USER}@${HOSTNAME}.local && \
    git config --global color.ui auto

# Work in the build directory, repo is expected to be init'd here
WORKDIR /src

# This is where the magic happens~
ENTRYPOINT ["/bin/bash"]
