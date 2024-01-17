#!/bin/bash

: << 'FUGA'

USAGE
        count-uniq.sh [-v] [--verbose] DIR[ DIR2[ DIR3 ...]]

DESCRIPTION
        Report how many uniquely named files there are in a directory, when the file ext is removed.

OPTIONS
        -v --verbose
        print each unique to stdout

COPYRIGHT
        Copyright © 2024 BloatedMonke
        License GPLv3: <https://gnu.org/licenses/gpl.html>.
        This is free software: you are free to change and redistribute it so long as
        the above copyright notice is retained.
FUGA

# based on: uniq < <(for x in $(ls); do echo ${x%.*}; done;)

report()
{
  readarray -t FILES < <(find "$1" -maxdepth 1 -type f)
  readarray -t UFILES < <(sort -u < <(IFS=''; for x in ${FILES[@]}; do echo ${x%.*}; done;))
  if [ $VERBOSE_SET -eq 1 ]; then
    IFS=''
    for x in ${UFILES[@]}; do
      echo $x
    done
    echo ""
  fi
  echo $1:: ${#UFILES[@]}
}

VERBOSE_SET=0
while [ -n "$1" ]; do
  if [ "$1" = "-v" ] || [ "$1" = "--verbose" ]; then
    VERBOSE_SET=1
    shift
  fi
  report $1
  shift
done;

