clc;
clear all;
Type = 'HOG';
xmlfile = 'detectorFile.xml';
load('positiveInstances_gray.mat');
trainCascadeObjectDetector(xmlfile, positiveInstances_gray,...
    'negativeFolder', 'NumCascadeStages', 3, 'FalseAlarmRate', 0.01,...
    'FeatureType', Type);

WhaleDetectorMdl = vision.CascadeObjectDetector(xmlfile);