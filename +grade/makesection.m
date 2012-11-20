function [section] = makesection(images, captions, matrix)

section.images = images;
section.captions = captions;
if nargin > 2 
    section.matrix = matrix;
end

return;