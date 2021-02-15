#!/bin/sh
set -e

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for chipsd"

  set -- chipsd "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "chipsd" ]; then
  mkdir -p "$CHIPS_DATA"
  chmod 700 "$CHIPS_DATA"
  chown -R chips "$CHIPS_DATA"

  echo "$0: setting data directory to $CHIPS_DATA"

  set -- "$@" -datadir="$CHIPS_DATA"
fi

if [ "$1" = "chipsd" ] || [ "$1" = "chips-cli" ] || [ "$1" = "chips-tx" ]; then
  echo
  exec su-exec chips "$@"
fi

echo
exec "$@"