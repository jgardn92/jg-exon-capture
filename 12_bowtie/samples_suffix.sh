#!/bin/bash
set -e
set -u
set -o pipefail
while read -r SNUM
 do
  echo $SNUM
  ls ../1_trimmed/ | grep $SNUM >> test3/sample_list_suffix.txt
done < test3/snum_list.txt
