# Compute cross correlation between smith ICA components & various brainmap ICA

projdir="/Volumes/Journal.Research.1/Projects/ADS/analysis/conn.rest/xcorr/20ICA-validation"
maskf="/Applications/MATLAB_R2015b.app/toolbox/spm12"
savedir="$projdir/calc/ica20.v.brainmap20"

test=$(ls $projdir/brainmap20/*.nii)
images=$(ls $projdir/canonical/smith20/*.nii)

if [ ! -d $savedir ]; then
	mkdir -p $savedir
fi

for i in $images; do
	for t in $test; do
		mricalc_xcorr -x $t -y $i -m $maskf -s $savedir -p -d -j
	done
done