#!/bin/bash
echo "[*] Installing dependencies"
apt-get install -y libcap-dev golang 1>/dev/null
go get -u github.com/liamg/furious 1>/dev/null
go_dir=$(go env | grep GOPATH | awk -F'"' '{print $2}')
echo "[*] Copied binaries to /usr/bin"
cp $go_dir/bin/furious /usr/bin
cp ./scan.sh /usr/bin/scan
