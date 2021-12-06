#!/bin/bash
set -e
set -u
set -o pipefail
echo "Checking file"
while read -r SNUM
 do
  LINECHECK=$(grep $SNUM test3/specimen_list.txt | wc -l)
  if [ "$LINECHECK" -ne "1" ]
  then
    echo "$SNUM lines don't match"
  fi
done < test3/snum_list.txt
