#/bin/bash

# Compute cross correlation between ICA components & various canonical templates
projdir="/Volumes/ADS.Archive.1/ADS/analysis/conn.rest/xcorr/20ICA-validation"
maskf="/Applications/MATLAB_R2015b.app/toolbox/spm12/toolbox/FieldMap/brainmask.nii"

# test ICA data
data=$(ls $projdir/ica/*.nii)

# Canonical templates

# 1. Brainmap ICA components
images=$(ls $projdir/canonical/brainmap20/*.nii)
savedir="$projdir/brainmap20.v.ica20"
# cross correlate datasets
dsxcorr -x "$images" -y "$data" -m 'pearson' -s "$savedir" -k "$maskf"
dsxcorr -x "$images" -y "$data" -m 'dice' -s "$savedir" -k "$maskf"
dsxcorr -x "$images" -y "$data" -m 'jaccard' -s "$savedir" -k "$maskf"


# 2. Smith Resting State ICA Networks (matches with Brainmap ICA components)
#images=$(ls $projdir/canonical/smith20/*.nii)
#savedir="$projdir/ica20.v.smith20"
# cross correlate datasets
#dsxcorr -x "$images" -y "$data" -m 'pearson' -s "$savedir" -k "$maskf"
#dsxcorr -x "$images" -y "$data" -m 'jaccard' -s "$savedir" -k "$maskf"
#dsxcorr -x "$images" -y "$data" -m 'dice' -s "$savedir" -k "$maskf"

# 3. FIND Networks
#images=$(ls $projdir/canonical/'find'/*.nii)
#savedir="$projdir/ica20.v.find"
# cross correlate datasets
#dsxcorr -x "$images" -y "$data" -m 'pearson' -s "$savedir" -k "$maskf"
#dsxcorr -x "$images" -y "$data" -m 'jaccard' -s "$savedir" -k "$maskf"
#dsxcorr -x "$images" -y "$data" -m 'dice' -s "$savedir" -k "$maskf"

# 4. Kanwisher
#images=$(ls $projdir/canonical/kanwisher-face/*.nii)
#savedir="$projdir/ica20.v.kanwisher-face"
# cross correlate datasets
#dsxcorr -x "$images" -y "$data" -m 'pearson' -s "$savedir" -k "$maskf"
#dsxcorr -x "$images" -y "$data" -m 'jaccard' -s "$savedir" -k "$maskf"
#dsxcorr -x "$images" -y "$data" -m 'dice' -s "$savedir" -k "$maskf"