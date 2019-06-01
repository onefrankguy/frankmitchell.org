<!--
title: Install TQSL v2.3.1 on Raspian Jessie
created: 1 Janupay 2018 - 8:47 am
updated: 1 January 2018 - 10:44 am
publish: 1 January 2018
slug: tqsl-pi
tags: coding, radio
-->

With the [International Grid Chase 2018][grid] contest starting, I wanted to
make sure I had TQSL working on the computer in the lab. TQSL is an application
used to sign and upload contacts to [Logbook of the World][lotw] so they count
for the contest. Since TQSL doesn't have pre-built binaries for Linux, and the
lab computer is a [Raspberry Pi 3][pi], I built the code from source.

The first thing to do is [download the TQSL source][source].

    curl -s https://www.arrl.org/files/file/LoTW%20Instructions/tqsl-latest.tar.gz > tqsl-latest.tar.gz

I couldn't find a checksum for the source package on the ARRL site. If you
downloaded version 2.3.1, you can check that you got the same package I did. If
you grabbed a later version, your checksum won't match.

    shasum -a 256 tqsl-latest.tar.gz
    bbbf7b4917384968a5f33907b637d3d9bff44b45a29ec5210894dfaa68a49281

Next unpack the tarball and read the installation instructions.

    tar -zxvf tqsl-latest.tar.gz
    cd tqsl-2.3.1
    cat INSTALL

The installation instructions are well written. They include a list of
dependencies (with versions), and a set of commands to run. The build system
uses [CMake][], so install that next.

    sudo apt-get install cmake

TQSL v2.3.1 depends on OpenSSL, expat, zlib, Berkeley DB, wxWidgets, and curl.
You need the development versions, the ones with libraries and headers.
Development package names typically include "lib" in the name and end in "-dev".
Run these commands to find the OpenSSL related development packages.

    apt-cache search ssl | grep -e "-dev"

Replace "ssl" in the search command above with "expat", "zlib", "db", "wx" and
"curl" to find the rest of the packages. Or just run the commands below to get
them all installed.

    sudo apt-get install libssl-dev
    sudo apt-get install libexpat1-dev
    sudo apt-get install zlib1g-dev
    sudo apt-get install libdb-dev
    sudo apt-get install libwxgtk3.0-dev
    sudo apt-get install libcurl4-openssl-dev

By default, the TQSL build process creates a shared library and installs it in
the /usr/local/lib$(LIB\_SUFFIX)/ directory. Shared libraries on Raspbian are
usually in the /usr/local/lib/ directory. Set an empty LIB\_SUFFIX
environment variable to make the build system puts things in the right place.

    export LIB_SUFFIX=""

Finally, run the commands from the installation instructions to compile and
install the TQSL library and application.

    cmake .
    make
    sudo make install

So far, I've been starting TQSL by running "tqsl" from the command line. I'd
like to put a shortcut into **Menu > Hamradio** so it's easier to start. I'll
update this post if and when I figure out how to do that.


[grid]: http://www.arrl.org/international-grid-chase-2018 "Bart Jahnke, W9JJ (ARRL): Internationl Grid Chase 2018"
[lotw]: https://lotw.arrl.org/lotw-help/ "Various (ARRL): Introducing Logbook of the World"
[pi]: https://www.raspberrypi.org/products/raspberry-pi-3-model-b/ "Various (Raspberry Pi Foundation): Raspberry Pi 3 Model B"
[source]: https://lotw.arrl.org/lotw-help/installation/ "Various (ARRL): Installing or Upgrading TQSL"
[CMake]: https://cmake.org/ "Various (Kitware): CMake is an open-source, cross-platform family of tools designed to build, test and package software"
