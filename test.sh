#!/bin/bash
set -e
set -u
set -o pipefail
line="Danio_rerio.1.18296121.18296321.fas"
sequence=$(grep -A1 CAMB_UW152101_S459 2_assemble_result/nf/$line || [[ $? == 1 ]])
if test -z "$sequence"
then
  echo "\$sequence is empty"
else
  gene=">${line}"
  echo $gene >> test.txt
  set -- $sequence
  echo $2 >> test.txt
fi
