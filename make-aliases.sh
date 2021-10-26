#!/bin/sh

# This script creates shell scripts that simulate adding all of the WiX binaries
# to the PATH. `wine /home/wine/wix/light.exe will be able to be called with
# just `light`.

binpath=/usr/local/bin

for exe in $(ls /usr/local/share/wix | grep .exe$); do
    name=$(echo $exe | cut -d '.' -f 1)

    cat > $binpath/$name << EOF
#!/bin/sh
wine /usr/local/share/wix/$exe \$@
EOF
    chmod +x $binpath/$name
done
