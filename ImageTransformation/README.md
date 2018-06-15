# ImageProcessing
This repo involves basic image processing projects 

The application addressed in this exercise is stitching images of geometrical maps. Figure 1 shows four images
of nautical maps. The images partly overlap. The purpose of this exercise is to get a single image which is
geometrically correct so that it can be used for navigation. First the images are glued together in a single image,
which is then processed to undo the geometrical deformation. We start with image 1. This is the image to which
the other images will be glued. In the first parts of this exercise, the image stitching will be done sequentially
(one image after another). The end result will then depend on the order in which we process the image. In the
last part of this exercise, we consider stitching all images together in one go. That is, finding the geometrical
transforms of all three images in a single optimization step. In this latter case, the order in which the images are
processed will not influence the end result.

