clear all
close all

CHECKPOINT=false;
% CHECKPOINT=true;

% addpath('./')
% run('../../vlfeat/toolbox/vl_setup');

% Load the whole set of training images.
[train_images_tot, train_labels_tot, class_names] = load_images('train5.mat');
% Create parameters.
feature_size = [400 1000 4000];
sample_method = {'key', 'dense'};
colorspace = {'grey', 'rgb', 'orgb'};
% Prepare the training features, labels and vocabulary for training the SVM
% classifier and for later evaluation.
sm = sample_method{1};
cs = colorspace{1};
nc = feature_size(1);
% nc = 100;

log_file = fopen(sprintf('%s/log/%d_%s_%s_log.txt', '.', nc, sm, cs), 'w')


if CHECKPOINT
    load(sprintf('%s/data/%d_%s_%s_data_f.mat', '.', nc, sm, cs), 'train_features')
    load(sprintf('%s/data/%d_%s_%s_data_l.mat', '.', nc, sm, cs), 'train_labels');
    disp('finish loading trainset')
else
    [train_features, train_labels, vocabulary]= prepare_training(train_images_tot, train_labels_tot, nc, sm, cs);
    disp('finish loading trainset')
    save(sprintf('%s/data/%d_%s_%s_data_f.mat', '.', nc, sm, cs), 'train_features');
    save(sprintf('%s/data/%d_%s_%s_data_l.mat', '.', nc, sm, cs), 'train_labels');
    disp('finish saving trainset')
end



if CHECKPOINT
    
    load(sprintf('%s/data/%d_%s_%s_classifiers.mat', '.', nc, sm, cs), 'classifiers');
else
    classifiers = train_classifiers(train_features);
    disp('finish training')
    save(sprintf('%s/data/%d_%s_%s_classifiers.mat', '.', nc, sm, cs), 'classifiers');
    disp('finish saving training model')
end



% Load the whole set of evaluation images.
[test_images_tot, test_labels_tot, ~] = load_images('test5.mat');

disp('finish loading testset')

if CHECKPOINT
    load(sprintf('%s/data/%d_%s_%s_test_data_f.mat', '.', nc, sm, cs), 'test_features');
    load(sprintf('%s/data/%d_%s_%s_test_data_l.mat', '.', nc, sm, cs), 'test_labels');
else
    [test_features, test_labels] = prepare_evaluation(test_images_tot, test_labels_tot, vocabulary, sm, cs);
    save(sprintf('%s/data/%d_%s_%s_test_data_f.mat', '.', nc, sm, cs), 'test_features');
    save(sprintf('%s/data/%d_%s_%s_test_data_l.mat', '.', nc, sm, cs), 'test_labels');
end

[inds, map, APs] = evaluateSVM(test_features, classifiers);
disp('finish evaluation')
fprintf(log_file, '%.2f\n', map);
fprintf(log_file, "APs:\n");
for i = 1:size(APs,1)
    fprintf(log_file, ".2f\n", APs(i,1));
end

disp(sprintf('%f', map));

for i = 1:size(inds,1)
    ind=inds{i};
    length=size(ind,1);
    front_ind=ind(1:5);
    end_ind=ind(length-5:length);
    for j = 1:5
        tmp_img = squeeze(test_images_tot(front_ind(j),:,:,:));
        saveas(tmp_img, sprintf('%s/images/%d_%s_%s_img_front_%d.png', '.', nc, sm, cs, j));
        tmp_img = squeeze(test_images_tot(end_ind(j),:,:,:));
        saveas(tmp_img, sprintf('%s/images/%d_%s_%s_img_end_%d.png', '.', nc, sm, cs, j));
    end
end
fclose(log_file);
% exit