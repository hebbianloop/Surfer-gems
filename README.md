<snippet>
  <content>
# 💎🏄 Surfer-gems 
A collection of tools for automating routine tasks &amp; performing analysis with the FreeSurfer software package.
## Installation
Simply clone this repository, and either copy them to your user bin folder or add the repo to your shell path.
## Contents
- FS-stats       -- Generates concatenated tables of morphometry statistics across FreeSurfer processed subjects
- FSQC-summary   -- Generates QC data for a single subject.
- FSQC-check     -- Generates QC data for a list of subjects and writes a list of subjects with failed analyses.  
- FSQC-makehtml  -- Generate webpage with screenshots of final subject reconstructions
- doc            -- LaTeX folder for FreeSurfer documentation
- nextractomatic -- DICOM extraction & conversion using dcm2niix @ CFMI (single subject)
- nextract.batch -- Batch DICOM extraction & conversion using dcm2niix
- recon-all-go   -- Serial script for batch FreeSurfer processing
- ship-data      -- Wrapper for rsync function
## History
A more complete version history can be found at www.github.com/seldamat/SNIR.  All of these executables were copied from the SNIR repo and consolidated into a FreeSurfer specific repository.  The developer has committed to updating this repository first for the included software and documentation.
## Credits
Shady El Damaty has developed the software in this repo with great help from the FreeSurfer wiki, mailing list and numerous online resources.
## License
   Copyright {2016} {Shady El Damaty}

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
## Contributing
1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D
</content>
</snippet>
