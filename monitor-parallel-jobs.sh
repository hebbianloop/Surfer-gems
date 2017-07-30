#!/bin/bash

# get current subjects running 
subs=$(ps aux | grep '[/]Volumes/CFMI-CFS/opt/fs6/bin/recon-all -all -parallel -make all -qcache -3T -noappend -brainstem-structures -hippocampal-subfields-T1 -s' | awk '{print $NF}')

echo '📌  Status of Current Recon Jobs'
counter=1
# loop through and print current status
for sub in $subs; do 
echo "⚙  $counter $sub ::"
printf '\t%s' "$(tail -n 1 $sub/scripts/recon-all-status.log)"
echo -e '\n'
((counter ++))
done