clc;
clear all;
Type = 'HOG';
xmlfile = 'detectorFile.xml';
load('positiveInstances_gray.mat');
trainCascadeObjectDetector(xmlfile, positiveInstances_gray,...
    'negativeFolder', 'NumCascadeStages', 10, 'FalseAlarmRate', 0.2,...
    'FeatureType', Type);

WhaleDetectorMdl = vision.CascadeObjectDetector(xmlfile);