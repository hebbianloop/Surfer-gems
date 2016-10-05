#!/bin/bash
set -x

InputFreesurferSubjectDirectory=$1

CaretAtlasDirectory=/Volumes/Archive.ADS/ADS/data/rois/standard_mesh_atlases
FreeSurferInstallationDirectory=/Applications/freesurfer
OutputRootDir=/Volumes/Archive.ADS/ADS/data/rois/meshes
#InitialMeshDirectory=/Volumes/Archive.ADS/ADS/data/rois/120subs
InitialMeshDirectory=InitialMesh

ReplaceOutputSubjectDirectory=true
Species="Human"

Subject=`basename $InputFreesurferSubjectDirectory`

#Wipe the slate clean, but just this subject. ;-)
if [ "$ReplaceOutputSubjectDirectory" ] ; then
  rm -rf $"$OutputRootDir"/"$Subject"
fi

#Make some directories for this and later scripts
if [ ! -e $OutputRootDir ] ; then
  mkdir -p $OutputRootDir
fi
if [ ! -e $OutputRootDir/$Subject ] ; then
  mkdir -p $OutputRootDir/$Subject
fi
if [ ! -e $OutputRootDir/$Subject/$InitialMeshDirectory ] ; then
  mkdir $OutputRootDir/$Subject/$InitialMeshDirectory
fi
if [ ! -e $OutputRootDir/$Subject/fsaverage ] ; then
  mkdir $OutputRootDir/$Subject/fsaverage
fi

#Axialize orig to LPI orientation, for proper viewing in caret5
$FreeSurferInstallationDirectory/bin/mri_convert "$InputFreesurferSubjectDirectory"/mri/orig.mgz --reslice_like $CaretAtlasDirectory/grid_lpi.nii.gz -rt nearest "$OutputRootDir"/"$Subject"/orig_lpi.nii.gz
#Affine transform orig to MNI atlas space, using talairach_avi xfm/t4
$FreeSurferInstallationDirectory/bin/mri_convert "$OutputRootDir"/"$Subject"/orig_lpi.nii.gz --apply_transform "$InputFreesurferSubjectDirectory"/mri/transforms/talairach.xfm -oc 0 0 0 "$OutputRootDir"/"$Subject"/orig_mni.nii.gz
#Find c_ras offset between FreeSurfer surface and volume and generate matrix to transform surfaces
MatrixX=`mri_info --cras $InputFreesurferSubjectDirectory/mri/orig.mgz | cut -f1 -d' '`
MatrixY=`mri_info --cras $InputFreesurferSubjectDirectory/mri/orig.mgz | cut -f2 -d' '`
MatrixZ=`mri_info --cras $InputFreesurferSubjectDirectory/mri/orig.mgz | cut -f3 -d' '`
Matrix1=`echo "1 0 0 ""$MatrixX"`
Matrix2=`echo "0 1 0 ""$MatrixY"`
Matrix3=`echo "0 0 1 ""$MatrixZ"`
Matrix4=`echo "0 0 0 1"`
MatrixCRAS=`echo "$Matrix1"" ""$Matrix2"" ""$Matrix3"" ""$Matrix4"`

#Extract talairach_avi affine matrix for surface transformation
MatrixMNI="`tail -3 "$InputFreesurferSubjectDirectory"/mri/transforms/talairach.xfm | tr -d ';'` 0.0 0.0 0.0 1.0"

#Loop through left and right hemispheres
for Hemisphere in L R ; do
  #Set different ways of saying left and right
  if [ $Hemisphere = "L" ] ; then 
    hemisphere="l"
    hemispherew="left"
  elif [ $Hemisphere = "R" ] ; then 
    hemisphere="r"
    hemispherew="right"
  fi
  
  #native Mesh Processing
  #Make caret5 spec files for orig and MNI spaces
  DIR=`pwd`
  cd $OutputRootDir/$Subject/$InitialMeshDirectory
  caret_command -spec-file-create $Species $Subject $hemispherew OTHER -category Individual -spec-file-name $Subject.$Hemisphere.mni+orig.initial_mesh.spec
  cd $DIR
  #Convert and translate surfaces to align with orig.mgz; add each to the appropriate spec file
  for Surface in white pial ; do
    caret_command -file-convert -sc -is FSS "$InputFreesurferSubjectDirectory"/surf/"$hemisphere"h."$Surface" -os CARET $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere."$Surface"_orig.initial_mesh.coord.gii $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.initial_mesh.topo.gii FIDUCIAL CLOSED -struct $hemispherew
    caret_command -surface-apply-transformation-matrix $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere."$Surface"_orig.initial_mesh.coord.gii $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.initial_mesh.topo.gii $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere."$Surface"_orig.initial_mesh.coord.gii -matrix $MatrixCRAS
    caret_command -spec-file-add $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.mni+orig.initial_mesh.spec FIDUCIALcoord_file $Subject.$Hemisphere."$Surface"_orig.initial_mesh.coord.gii
  done
  #Add more files to spec file
  caret_command -spec-file-add $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.mni+orig.initial_mesh.spec volume_anatomy_file ../orig_lpi.nii.gz
  caret_command -spec-file-add $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.mni+orig.initial_mesh.spec CLOSEDtopo_file $Subject.$Hemisphere.initial_mesh.topo.gii
  #Create midthickness surface by averaging white and pial surfaces
  caret_command -surface-average $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.midthickness_orig.initial_mesh.coord.gii $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.pial_orig.initial_mesh.coord.gii $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.white_orig.initial_mesh.coord.gii
  caret_command -spec-file-add $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.mni+orig.initial_mesh.spec FIDUCIALcoord_file $Subject.$Hemisphere.midthickness_orig.initial_mesh.coord.gii
  #Apply talairach.xfm to white, midthickness, & pial surfaces
  for Surface in white midthickness pial ; do
    caret_command -surface-apply-transformation-matrix $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere."$Surface"_orig.initial_mesh.coord.gii $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.initial_mesh.topo.gii $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere."$Surface"_mni.initial_mesh.coord.gii -matrix $MatrixMNI
    caret_command -spec-file-add $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.mni+orig.initial_mesh.spec FIDUCIALcoord_file $Subject.$Hemisphere."$Surface"_mni.initial_mesh.coord.gii
  done
  #Convert original and registered spherical surfaces, make sure they are centered on 0,0,0 and add them to the spec file
  for Surface in sphere.reg sphere ; do
    caret_command -file-convert -sc -is FSS "$InputFreesurferSubjectDirectory"/surf/"$hemisphere"h."$Surface" -os CARET $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere."$Surface".initial_mesh.coord.gii $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.initial_mesh.topo.gii SPHERICAL CLOSED -struct $hemispherew
    caret_command -surface-sphere $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere."$Surface".initial_mesh.coord.gii $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.initial_mesh.topo.gii $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere."$Surface".initial_mesh.coord.gii
    caret_command -spec-file-add $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.mni+orig.initial_mesh.spec SPHERICALcoord_file $Subject.$Hemisphere."$Surface".initial_mesh.coord.gii
  done
  #Add more files to the spec file and convert other FreeSurfer surface data to metric/GIFTI including sulc, curv, and thickness.
  caret_command -spec-file-add $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.mni+orig.initial_mesh.spec volume_anatomy_file ../orig_mni.nii.gz
  caret_command -spec-file-add $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.mni+orig.initial_mesh.spec CLOSEDtopo_file $Subject.$Hemisphere.initial_mesh.topo.gii
  caret_command -file-convert -fsc2c "$InputFreesurferSubjectDirectory"/surf/"$hemisphere"h.sulc "$InputFreesurferSubjectDirectory"/surf/"$hemisphere"h.white $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.sulc.initial_mesh.shape.gii
  caret_command -spec-file-add $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.mni+orig.initial_mesh.spec surface_shape_file $Subject.$Hemisphere.sulc.initial_mesh.shape.gii
  caret_command -spec-file-add $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.mni+orig.initial_mesh.spec metric_file $Subject.$Hemisphere.sulc.initial_mesh.shape.gii
  caret_command -file-convert -fsc2c "$InputFreesurferSubjectDirectory"/surf/"$hemisphere"h.thickness "$InputFreesurferSubjectDirectory"/surf/"$hemisphere"h.white $OutputRootDir/$Subject/$InitialMeshDirectory/temp.shape.gii
  caret_command -metric-math $OutputRootDir/$Subject/$InitialMeshDirectory/temp.shape.gii $OutputRootDir/$Subject/$InitialMeshDirectory/temp.shape.gii 1 "abs[@1@]"
  caret_command -metric-composite-identified-columns $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.thickness.initial_mesh.shape.gii $OutputRootDir/$Subject/$InitialMeshDirectory/temp.shape.gii 1; rm $OutputRootDir/$Subject/$InitialMeshDirectory/temp.shape.gii
  caret_command -spec-file-add $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.mni+orig.initial_mesh.spec metric_file $Subject.$Hemisphere.thickness.initial_mesh.shape.gii
  caret_command -file-convert -fsc2c "$InputFreesurferSubjectDirectory"/surf/"$hemisphere"h.curv "$InputFreesurferSubjectDirectory"/surf/"$hemisphere"h.white $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.curvature.initial_mesh.shape.gii
  caret_command -spec-file-add $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.mni+orig.initial_mesh.spec surface_shape_file $Subject.$Hemisphere.curvature.initial_mesh.shape.gii
  caret_command -spec-file-add $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.mni+orig.initial_mesh.spec metric_file $Subject.$Hemisphere.curvature.initial_mesh.shape.gii
  #Generate Caret style inflated surfaces
  caret_command -surface-generate-inflated $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.midthickness_mni.initial_mesh.coord.gii $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.initial_mesh.topo.gii -iterations-scale 2.5 -generate-inflated -generate-very-inflated -output-spec $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.mni+orig.initial_mesh.spec -output-inflated-file-name $Subject.$Hemisphere.inflated.initial_mesh.coord.gii -output-very-inflated-file-name $Subject.$Hemisphere.very_inflated.initial_mesh.coord.gii
  mv $Subject.$Hemisphere.inflated.initial_mesh.coord.gii $Subject.$Hemisphere.very_inflated.initial_mesh.coord.gii $OutputRootDir/$Subject/$InitialMeshDirectory/

  #Copy fsaverage data to subject's Directory, ensure spheres are properly centered
  cp "$CaretAtlasDirectory"/fs_"$Hemisphere"/fsaverage.$Hemisphere.closed.164k_fs_"$Hemisphere".topo $OutputRootDir/$Subject/fsaverage/$Subject.$Hemisphere.164k_fs_"$Hemisphere".topo.gii
  cp "$CaretAtlasDirectory"/fs_"$Hemisphere"/fsaverage.$Hemisphere.sphere.164k_fs_"$Hemisphere".coord $OutputRootDir/$Subject/fsaverage/$Subject.$Hemisphere.sphere.164k_fs_"$Hemisphere".coord.gii

  cp "$CaretAtlasDirectory"/fs_"$Hemisphere"/fs_"$Hemisphere"-to-fs_LR_fsaverage."$Hemisphere"_LR.spherical_std.164k_fs_"$Hemisphere".coord $OutputRootDir/$Subject/fsaverage/$Subject.$Hemisphere.def_sphere.164k_fs_"$Hemisphere".coord.gii
  caret_command -surface-sphere $OutputRootDir/$Subject/fsaverage/$Subject.$Hemisphere.def_sphere.164k_fs_"$Hemisphere".coord.gii $OutputRootDir/$Subject/fsaverage/$Subject.$Hemisphere.164k_fs_"$Hemisphere".topo.gii $OutputRootDir/$Subject/fsaverage/$Subject.$Hemisphere.def_sphere.164k_fs_"$Hemisphere".coord.gii
  caret_command -surface-sphere $OutputRootDir/$Subject/fsaverage/$Subject.$Hemisphere.sphere.164k_fs_"$Hemisphere".coord.gii $OutputRootDir/$Subject/fsaverage/$Subject.$Hemisphere.164k_fs_"$Hemisphere".topo.gii $OutputRootDir/$Subject/fsaverage/$Subject.$Hemisphere.sphere.164k_fs_"$Hemisphere".coord.gii

  #Copy fs_LR data to subject's Directory, ensure spheres are properly centered
  cp "$CaretAtlasDirectory"/fsaverage.$Hemisphere.closed.164k_fs_LR.topo $OutputRootDir/$Subject/$Subject.$Hemisphere.164k_fs_LR.topo.gii
  cp "$CaretAtlasDirectory"/fsaverage."$Hemisphere"_LR.spherical_std.164k_fs_LR.coord $OutputRootDir/$Subject/$Subject.$Hemisphere.sphere.164k_fs_LR.coord.gii
  caret_command -surface-sphere $OutputRootDir/$Subject/$Subject.$Hemisphere.sphere.164k_fs_LR.coord.gii $OutputRootDir/$Subject/$Subject.$Hemisphere.164k_fs_LR.topo.gii $OutputRootDir/$Subject/$Subject.$Hemisphere.sphere.164k_fs_LR.coord.gii

  #Unproject fs_L|R meshes to fs_LR mesh
  caret_command -surface-sphere-project-unproject $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.sphere.reg.initial_mesh.coord.gii $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.initial_mesh.topo.gii $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.sphere.reg.reg_LR.initial_mesh.coord.gii $OutputRootDir/$Subject/fsaverage/$Subject.$Hemisphere.sphere.164k_fs_"$Hemisphere".coord.gii $OutputRootDir/$Subject/fsaverage/$Subject.$Hemisphere.def_sphere.164k_fs_"$Hemisphere".coord.gii $OutputRootDir/$Subject/fsaverage/$Subject.$Hemisphere.164k_fs_"$Hemisphere".topo.gii
  #Create native to fs_LR deformation map
  caret_command -deformation-map-create SPHERE $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.sphere.reg.reg_LR.initial_mesh.coord.gii $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.initial_mesh.topo.gii $OutputRootDir/$Subject/$Subject.$Hemisphere.sphere.164k_fs_LR.coord.gii $OutputRootDir/$Subject/$Subject.$Hemisphere.164k_fs_LR.topo.gii $OutputRootDir/$Subject/initial_mesh_to_164k_fs_LR.$Hemisphere.deform_map
  #Create fs_LR to native (inverse) deformation map
  caret_command -deformation-map-create SPHERE $OutputRootDir/$Subject/$Subject.$Hemisphere.sphere.164k_fs_LR.coord.gii $OutputRootDir/$Subject/$Subject.$Hemisphere.164k_fs_LR.topo.gii $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.sphere.reg.reg_LR.initial_mesh.coord.gii $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.initial_mesh.topo.gii $OutputRootDir/$Subject/164k_fs_164k_fs_LR_to_initial_mesh.$Hemisphere.deform_map

  #Create and populate fs_LR spec file.
  sed 's/initial_mesh/164k_fs_LR/g' $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.mni+orig.initial_mesh.spec | sed 's#../##g' | grep -v sphere.reg > $OutputRootDir/$Subject/$Subject.$Hemisphere.mni+orig.164k_fs_LR.spec
  grep -v "_mni" $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.mni+orig.initial_mesh.spec > $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.orig.initial_mesh.spec
  grep -v "_orig" $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.mni+orig.initial_mesh.spec > $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.mni.initial_mesh.spec
  grep -v "_mni" $OutputRootDir/$Subject/$Subject.$Hemisphere.mni+orig.164k_fs_LR.spec > $OutputRootDir/$Subject/$Subject.$Hemisphere.orig.164k_fs_LR.spec
  grep -v "_orig" $OutputRootDir/$Subject/$Subject.$Hemisphere.mni+orig.164k_fs_LR.spec > $OutputRootDir/$Subject/$Subject.$Hemisphere.mni.164k_fs_LR.spec
  #Deform surfaces and other data according to native to fs_LR deformation map.
  for Space in orig mni ; do
    for Surface in white midthickness pial ; do
      caret_command -deformation-map-apply $OutputRootDir/$Subject/initial_mesh_to_164k_fs_LR.$Hemisphere.deform_map COORDINATE $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere."$Surface"_"$Space".initial_mesh.coord.gii $OutputRootDir/$Subject/$Subject.$Hemisphere."$Surface"_"$Space".164k_fs_LR.coord.gii 
    done
  done
  for Feature in curvature sulc thickness ; do
    Shape=`ls $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.$Feature.initial_mesh.shape.gii`
    NewShape=`basename $Shape | sed 's/initial_mesh.shape/164k_fs_LR.shape/g'`
    caret_command -deformation-map-apply $OutputRootDir/$Subject/initial_mesh_to_164k_fs_LR.$Hemisphere.deform_map METRIC_AVERAGE_TILE $Shape $OutputRootDir/$Subject/$NewShape
  done
  for Surface in inflated very_inflated ; do
    caret_command -deformation-map-apply $OutputRootDir/$Subject/initial_mesh_to_164k_fs_LR.$Hemisphere.deform_map COORDINATE $OutputRootDir/$Subject/$InitialMeshDirectory/$Subject.$Hemisphere.$Surface.initial_mesh.coord.gii $OutputRootDir/$Subject/$Subject.$Hemisphere."$Surface".164k_fs_LR.coord.gii
  done
  i=1
done

######################################################
exit
######################################################
      caret_command -surface-sphere-project-unproject  
         1<input-spherical-coordinate-file-name>
         2<input-spherical-topology-file-name>
         3<output-spherical-coordinate-file-name>
         4<project-to-spherical-coordinate-file-name>
         5<unproject-to-spherical-coordinate-file-name>
         6<project-unproject-spherical-topology-file-name>
         
         Transform a spherical surface.
         
         The input spherical surface is projected to the 
         "project-to" surface using barycentric projections
         and then unprojected using the "unproject-to" 
         spherical surface.  Typically the "unproject-to"
         surface is created during surface-based registration
         of the "project-to" spherical surface to some
         target.

