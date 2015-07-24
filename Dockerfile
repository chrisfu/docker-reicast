# This builds an Ubuntu package for the latest git HEAD Reicast commit.
# Only 64-bit builds are supported currently.
FROM ubuntu:trusty
MAINTAINER Chrisfu <chrisfu@gmail.com>

# Enable 32-bit packages
#RUN dpkg --add-architecture i386

# Update image
RUN apt-get -q update &&\
    apt-get -qy --force-yes dist-upgrade

# Install Reicast build dependancies
RUN apt-get install -qy --force-yes\
    git\
    gcc\
    gcc-4.8-multilib\
    g++-4.8-multilib\
    build-essential\
    dpkg-dev\
    ruby-dev\
    lib32z1-dev\
    lib32bz2-dev\
#    libasound2-dev:i386\
#    libgl1-mesa-dev:i386
    libasound2-dev\
    libgl1-mesa-dev

# Create volume mount points
#RUN mkdir /reicast /packages /build_i386 /build_x86_64
RUN mkdir /reicast /packages /build_x86_64

# Install FPM to build Debian package
RUN gem install fpm

# Install changelogger to generate changelogs from Git history
RUN gem install changelogger

# Clean up archived packages to trim image size
RUN apt-get clean &&\
    rm -rf /var/lib/apt/lists/* &&\
    rm -rf /tmp/*

VOLUME ["/reicast","/packages","/build_i386","/build_x86_64"]

ADD ./build.sh /build.sh
RUN chmod u+x /build.sh

# The command below here gets executed by default when the container is "run" with the `docker run` command
ENTRYPOINT ["/build.sh"]
