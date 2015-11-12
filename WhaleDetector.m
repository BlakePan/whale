clc;
clear all;
Type = 'HOG';
xmlfile = 'detectorFile.xml';
load('MAT/positiveInstances_merge.mat');
trainCascadeObjectDetector(xmlfile, positiveInstances_merge,...
    'negativeFolder', 'NumCascadeStages', 10, 'FalseAlarmRate', 0.2,...
    'FeatureType', Type, 'ObjectTrainingSize', [100,100]);

WhaleDetectorMdl = vision.CascadeObjectDetector(xmlfile);
save('MAT/WhaleDetectorMdl_100X100.mat', 'WhaleDetectorMdl');