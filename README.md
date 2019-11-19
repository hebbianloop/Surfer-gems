<snippet>
  <content>
    
# 💎🏄 Surfer-gems 
A collection of tools for automating routine tasks & performing analysis with the FreeSurfer software package.

Powered by GNU parallel.

## What does this do and how do I use it?
#### Check dataset for failed, successful, active jobs.
> `surfergems --subjects-dir ~/My-FreeSurfer-Data --status`

#### Check dataset file manifest
> `surfergems --subjects-dir ~/My-FreeSurfer-Data -f`

#### Generate summary of subject edits 
> `surfergems --subjects-dir ~/My-FreeSurfer-Data --edits-summary`

_parallelized for efficiency_
#### Make average surfaces/volumes and register subjects
> `surfergems --subjects-dir ~/My-FreeSurfer-Data --make-average`

_parallelized for efficiency_
#### Convert volumes 
> `surfergems --subjects-dir ~/My-FreeSurfer-Data --convert-vol T1 --convert-vol wm --iext mgz --oext nii.gz`

_parallelized for efficiency_
#### Convert surfaces
> `surfergems --subjects-dir ~/My-FreeSurfer-Data --convert-surf mysurf --oext .gii`

_parallelized for efficiency_
#### Deface subject
> `surfergems --subjects-dir ~/My-FreeSurfer-Data --deface -s sub-001_ses-001_run-01_T1w`

_parallelized for efficiency_
#### Extract morphometric statistics 
> `surfergems --subjects-dir ~/My-FreeSurfer-Data --morph-stats`

#### Summarize run time statistics 
> `surfergems --subjects-dir ~/My-FreeSurfer-Data --stats`

This will generate a tsv file in the subjects directory with the following fields

|  SubjectID  | Machine | JobStatus | TotalRunTime | ReconStage | NumBrainMaskEdits | NumWhiteMaskDel | NumWhiteMaskFill | TalCorr | OrigCNR | BrainMaskCNR | NumDefects | LEulerNo | REulerNo | 
| ----- | -----  | -----  | -----  | -----  | -----  | -----  | -----  | -----  | ----- | ----- | ----- | ----- | ----- | 
| sub-001_ses-001_run-01_T1w | keylime  | complete  | 00:20:04  | Skull  | 14663  | 0  | 0  | 0.97972  | 1.290 | 1.287 | 29 | -70 | -70 | 

#### Filter your operation by a specific list of subjects/sessions
> `surfergems --subjects-dir ~/My-FreeSurfer-Data --status -s sub-001_ses-001_run-01_T1w -s sub-001_ses-002_run-01_T1w`

#### Create an HTML web report of a dataset 
> `surfergems --subjects-dir ~/My-FreeSurfer-Data --make-web-report --web-report-dir ${HOME}/My-Web-Report`

See https://seldamat.github.io/Surfer-webgems for a demo of web reports.

_parallelized for efficiency_

## Local macOS Installation
Simply clone this repository and add it to your bash path by including the following line your `.bash_profile`
> `export PATH="<PATHTOSURFERGEMS>/:$PATH"`

Then enter the command to check for and install missing dependencies
> `surfer-gems --install`

The following dependencies are required

#### macOS
> bash v4.0 or greater

> homebrew package manager

> patched FreeSurfer v6.0

> miniconda3

> nilearn

> column

> java SDK v7 or greater

> GNU grep

> GNU coreutils

> GNU Parallel

## Installing with Docker
Build the container using the provided dockerfile
> `docker build . -t surfergems`

Once built, you can execute the container with the command
> `docker run -t surfergems <OPTS>`


## Contributing
1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## Credits
The software in this repo was developed with great help from the FreeSurfer wiki, mailing list and numerous online resources.

🙏 Thanks to Pierre Bellec for suggestions on using nilearn html generation code for visualizing surfaces with javascript.

🙏 Thanks to @akeshevan for help with papaya web viewer and FS lookup table

🙏 Thanks to Paul Kuntke for help containerizing this program.

</content>
</snippet>
