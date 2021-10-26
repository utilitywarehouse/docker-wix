FROM i386/alpine:3.13
MAINTAINER BTG <btg-engineering@uw.co.uk>

# Wine 32Bit for running EXE
RUN apk add --no-cache wine freetype wget ncurses-libs

ENV WINEPREFIX=/root/.wine WINEARCH=win32 WINEDEBUG=-all

# Install Winetricks
RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks -nv -O /usr/local/bin/winetricks \
    && chmod +x /usr/local/bin/winetricks

# Install .NET framework and WiX Toolset binaries
# Run winetricks to setup .NET DLLs
RUN wine wineboot && \
    wget https://dl.winehq.org/wine/wine-mono/6.4.0/wine-mono-6.4.0-x86.msi -nv -O mono.msi \
    && msiexec /i mono.msi \
    && rm -f mono.msi \
    && winetricks --unattended --force dotnet48

RUN wget https://github.com/wixtoolset/wix3/releases/download/wix3112rtm/wix311-binaries.zip -nv -O wix.zip \
    && mkdir /usr/local/share/wix \
    && unzip wix.zip -d /usr/local/share/wix \
    && rm -f wix.zip

COPY make-aliases.sh /root/make-aliases.sh
RUN /root/make-aliases.sh

RUN rm -rf /root/.wine/drive_c/users/wine/Temp/* /root/.cache/* \
    && rm -f /root/make-aliases.sh
