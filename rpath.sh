#!/bin/bash

if [ -z "$1" ]; then
  echo "You need to give the path for install."
  exit 1
fi

install_path="$1"

for file in `find "$install_path"/lib -type f -name "lib*.dylib"`; do
  for lib_path in $(otool -l $file | grep -A2 LC_LOAD_DYLIB | grep dylib | grep name | awk '{print $2}' | grep -v "@.*path" | grep -v "^/usr/lib/" | grep -v "^/usr/local/lib/" | grep -v "^/System"); do
    install_name_tool -change $lib_path @rpath/$(echo $lib_path | awk -F'/' '{print $(NF)}') $file
  done
done

for file in `find "$install_path"/ddb -type f -name "lib*.dylib"`; do
  for lib_path in $(otool -l $file | grep -A2 LC_LOAD_DYLIB | grep dylib | grep name | awk '{print $2}' | grep -v "@.*path" | grep -v "^/usr/lib/" | grep -v "^/usr/local/lib/" | grep -v "^/System"); do
    install_name_tool -change $lib_path @rpath/$(echo $lib_path | awk -F'/' '{print $(NF)}') $file
  done
done