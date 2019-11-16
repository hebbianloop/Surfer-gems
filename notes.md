# OHBM 2019 Hack-a-thon (Done)
# added exception for checking existence of subjects directory, had to move to end of parse opts to allow -sd input to propagate
# moved exception for report dir to end of parse opts
# reorganized files (clean up) and created parent call function 'surfergem'
# added dependency checks for parallel, freesurfer
# checked status and manifest functions (works!) 
# checked statistics summary (works!)
# added improved option parsing for the --web-report opt, now checks to make sure that argument following option is not another option i.e) '-' prefix and sets default SUBJECT list to those with 'done' status
# added single subject processing for subject-edits
# fixed bug with checking if input subject id matches existing subject in subjects_dir
# fixed bug with printing landing pages and nested tiles

## PRIMARY TODO 
x use nilearn write to html function to get surfaces working in html
x extract and embed surface morphometrics to html
x compile edits and project to surface
x *group average functions*
x 		--> average template (make_average_subject)
x		--> average morphometrics, edits, snr on surface
Once primary done:
**Update repository with done, need to update documentation and release to community**

## SECONDARY TODO
- rerun failed jobs
- add time started in SGE for status output
- exception check - does recon-all.log exist?
- think about how to show contrast to noise ratio
x should ANTs be added as a dependency?
x   --> maybe individual binaries can be compiled as dependencies
-		--> DenoiseImage noise estimation for SNR maps
- update documentation with java dependency
- add parsing of participant metadata (bids standard participants.tsv?)
