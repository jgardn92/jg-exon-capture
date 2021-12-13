#!/bin/bash
set -e
set -u
set -o pipefail
while read -r SNUM
 do
  echo $SNUM
  ls ../1_trimmed/ | grep $SNUM >> test4_remaining/sample_list_suffix.txt
done < test4_remaining/snum_list.txt
