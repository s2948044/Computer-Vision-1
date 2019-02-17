function [output_image] = rgb2grays(input_image)
% converts an RGB into grayscale by using 4 different methods

% ligtness method
[R, G, B] = getColorChannels(input_image);
size_image = size(input_image);
h = size_image(1);
w = size_image(2);
output_image_lightness = zeros(h,w);
for i = 1:h
    for j = 1:w
        output_image_lightness(i,j) = (max([R(i,j),G(i,j),B(i,j)]) + min([R(i,j),G(i,j),B(i,j)])) / 2;
    end
end
subplot(2,2,1);   
imshow(output_image_lightness)

% average method
output_image_average = (R + G + B) / 3;
subplot(2,2,2);   
imshow(output_image_average) 
% luminosity method
output_image_luminosity = 0.21 * R + 0.72 * G + 0.07 * B;
subplot(2,2,3);   
imshow(output_image_luminosity)  
% built-in MATLAB function 
output_image = rgb2gray(input_image);
subplot(2,2,4);   
imshow(output_image)
end

