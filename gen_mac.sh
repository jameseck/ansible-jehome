#!/bin/sh

if [ -n "$1" ]; then
  OID="52:54:00"
  RAND=$(echo $1 | md5sum | sed 's/\(..\)\(..\)\(..\).*/\1:\2:\3/')
  echo "$OID:$RAND"
else
  echo "ERROR: please supply hostname to create MAC address from, e.g.:"
  echo "       $0 myhost"
fi
