#!/bin/bash
set -e

if [[ $(echo "$1" | cut -c1) = "-" ]]; then
  echo "$0: assuming arguments for chipsd"

  set -- chipsd "$@"
fi

if [[ $(echo "$1" | cut -c1) = "-" ]] || [[ "$1" = "chipsd" ]]; then
  mkdir -p "$CHIPS_DATA"

  ls /usr/local/bin
  # chmod 700 "$CHIPS_DATA"
  # chown -R chips "$CHIPS_DATA"

  # echo "$0: setting data directory to $CHIPS_DATA"

  # set -- "$@" -datadir="$CHIPS_DATA"
fi

# if arguments are executed against chips, use the chips user
# if [ "$1" = "chipsd" ] || [ "$1" = "chips-cli" ]; then
#   echo
#   # exec gosu chips "$@"
# fi


# mkdir ~/.chips
# cd ~/.chips
# ls -l

# echo $PWD

# if [[ $1 == "true" ]]; then
#     wget http://bootstrap3rd.dexstats.info/CHIPS-bootstrap.tar.gz
#     tar xvzf CHIPS-bootstrap.tar.gz
#     rm CHIPS-bootstrap.tar.gz
# else
#     echo "skipping bootstrap"
# fi

# ls -l

# cd /opt/chips
# ./chipsd -daemon -txindex=1