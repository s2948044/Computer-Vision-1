image = imread('./images/image2.jpg');
image = im2double(image); % convert the input image to double space.
[Gx, Gy, im_mag, im_dir] = compute_gradient(image);
output = figure(1);
subplot(2,2,1);
imshow(Gx);
title('Grad. of image in x-direction');
subplot(2,2,2);
imshow(Gy);
title('Grad. of image in y-direction');
subplot(2,2,3);
imshow(im_mag);
title('Grad. magnitude of each pixel');
subplot(2,2,4);
imshow(im_dir);
title('Grad. direction of each pixel');
saveas(output,'./images_4.3/gradient.eps','epsc');