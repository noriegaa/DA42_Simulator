clear all
clc

addpath(pwd,genpath('Support Files'));
addpath(pwd,genpath('Tests'));
addpath(pwd,genpath('Validations'));

% Folder where to save the reports. It MUST exist before running
foldertosave = 'Reports';
modelname = 'DA42_Validations';

test2c10

addpath(pwd,foldertosave)
open 2c10_FAILED_Az_q_Theta.pdf