#/bin/bash

# Compute cross correlation between ICA components & various canonical templates

projdir="/Volumes/Journal.Research.1/Projects/ADS/analysis/conn.rest/xcorr/20ICA-validation"

maskf="/Applications/MATLAB_R2015b.app/toolbox/spm12"

test=$(ls $projdir/ica/*.nii)

# 1. Brainmap ICA components
images=$(ls $projdir/canonical/brainmap20/*.nii)
savedir="$projdir/calc/ica20.v.brainmap20"

if [ ! -d $savedir ]; then
	mkdir -p $savedir
fi

for i in $images; do
	for t in $test; do
		mricalc_xcorr -x $t -y $i -m $maskf -s $savedir -p -d -j
	done
done

# 2. Smith Resting State ICA Networks (matches with Brainmap ICA components)
images=$(ls $projdir/canonical/smith20/*.nii)
savedir="$projdir/calc/ica20.v.smith20"

if [ ! -d $savedir ]; then
	mkdir -p $savedir
fi

for i in $images; do
	for t in $test; do
		mricalc_xcorr -x $t -y $i -m $maskf -s $savedir -p -d -j
	done
done

# 3. FIND Networks
images=$(ls $projdir/canonical/find/*.nii)
savedir="$projdir/calc/ica20.v.find"

if [ ! -d $savedir ]; then
	mkdir -p $savedir
fi

for i in $images; do
	for t in $test; do
		mricalc_xcorr -x $t -y $i -m $maskf -s $savedir -p -d -j
	done
done

# 4. Kanwisher
images=$(ls $projdir/canonical/kanwisher-face/*.nii)
savedir="$projdir/calc/ica20.v.kanwisher-face"

if [ ! -d $savedir ]; then
	mkdir -p $savedir
fi

for i in $images; do
	for t in $test; do
		mricalc_xcorr -x $t -y $i -m $maskf -s $savedir -p -d -j
	done
done