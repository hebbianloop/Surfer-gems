<snippet>
  <content>
# 💎🏄 Surfer-gems 
A collection of tools for automating routine tasks &amp; performing analysis with the FreeSurfer software package.
## Installation
Simply clone this repository and add it to your bash path by including the following line your `.bash_profile`
> `export PATH="<PATHTOSURFERGEMS>/:$PATH"`

## Contents
- `launchfv`          -- Command line wrapper for freeview app
- `FS-stats`          -- Generates concatenated tables of morphometry statistics across FreeSurfer processed subjects
- `FSQC-summary`      -- Generates QC data for a single subject.
- `FSQC-check`        -- Generates QC data for a list of subjects and writes a list of subjects with failed analyses.  
- `FSQC-makehtml`     -- Generate webpage with screenshots of final subject reconstructions
- `recon-all-go`      -- Serial script for batch FreeSurfer processing
- `recon-all-pargo`   -- GNU parallel wrapper for batch FreeSurfer processing
- `recon-all-base`    -- Serial script for batch longitudinal FreeSurfer processing
- `execute_freesurfer_pipeline` -- Script that executes all freesurfer pipeline steps (recon-all-pargo, FSQC-check, FSQC-makehtml, FS-stats)
- doc               -- LaTeX folder for FreeSurfer documentation

## History
A more complete version history can be found at www.github.com/seldamat/SNIR.  All of these executables were copied from the SNIR repo and consolidated into a FreeSurfer specific repository.  The developer has committed to updating this repository first for the included software and documentation.

## Contributing
1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## Credits
The software in this repo was developed with great help from the FreeSurfer wiki, mailing list and numerous online resources.

</content>
</snippet>
