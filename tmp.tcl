labl_import_annotation "aparc.annot"
scale_brain 1.35
redraw
save_tiff README.lh.lat.hr.tif
rotate_brain_y 180.0
redraw
save_tiff README.lh.med.hr.tif
resize_window 300
rotate_brain_y -180.0
redraw
save_tiff README.lh.lat.lr.tif
rotate_brain_y 180.0
redraw
save_tiff README.lh.med.lr.tif
exit 0
