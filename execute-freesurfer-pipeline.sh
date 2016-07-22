# Excecute the FreeSurfer Pipeline
#
#	1. Run recon-all with GNU parallel
#	2. Output Run Time Statistics
# 	3. Generate QC statistics for all completed subjects
#   4. Generate failed subject list
# ------------------------------------------------------------------------------------------------------------
# Arguments 
ds=$(date)
subjectsdir="/Volumes/Archive.ADS/ADS/data/ads.subjects.trashcan"
subjectslist="w1.subjects.list"
rawdatadir="/Volumes/Archive.ADS/ADS/data/raw/w1"
rexp="Anat/*.nii"	
group="w1"
# ------------------------------------------------------------------------------------------------------------
# Excecute Recon-all in Parallel
recon-all-pargo -sd $subjectsdir -s $subjectslist -rd $rawdatadir -rexp $pattern -g $group 
# ------------------------------------------------------------------------------------------------------------
# Generate QC stats
qcdir="/Volumes/Archive.ADS/ADS/data/ads.subjects.trashcan.qc"
FSQC-check -qd $qcdir -sd $subjectsdir -g $groupname -sf $subjectslist -fsl w1.failed.subjects.list > $subjectsdir/FSQC-autocheck.info
# ------------------------------------------------------------------------------------------------------------
# Completed~!
cat <<EOF

■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
						🏁 FreeSurfer Pipeline Successfully Completed  🏁

										$me -- $ds
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

EOF