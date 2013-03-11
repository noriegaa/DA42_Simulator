
%% Test 2c10 Short Period Dynamics
testname = '2c10';
testname2 = 'Short Period Dynamics'; % For other reasons, dont delete
fdata = load('2c10.csv');

% Fix elevator
fdata(:,14) = -ta(:,14);

% Create the name to save the file
pathtosave = fullfile(pwd,foldertosave);
testname = strcat(pathtosave,'\',testname);

%% Get initial conditions
initu = mean(fdata(1:25,74));
initv = mean(fdata(1:25,75));
initw = mean(fdata(1:25,76));

initp = mean(fdata(1:25,5));
initq = mean(fdata(1:25,6));
initr = mean(fdata(1:25,7));

initbank = mean(fdata(1:25,8));
initpitch = mean(fdata(1:25,9));
inithead = mean(fdata(1:25,10));

initnorth = 0;
initeast = 0;
initalt = mean(fdata(1:25,30));

elevator = mean(fdata(1:25,14))*pi/180;
aileron = mean(fdata(1:25,15))*pi/180;
rudder = mean(fdata(1:25,16))*pi/180;
map    = mean(fdata(1:25,145))*0.000295301;

%% Trim the airplane
% Trim the airplane
            %MISSING%
            
% Find control bias
elebias = mean(fdata(1:25,14))*pi/180-elevator;
ailbias = mean(fdata(1:25,14))*pi/180-aileron;
rudbias = mean(fdata(1:25,14))*pi/180-rudder;
mapbias = mean(fdata(1:25,14))*0.000295301-map;

%% Run the simulation
sim(modelname,[fdata(1,1) fdata(end,1)]);

% Collect the output parameters of interest
output = simout.signals.values;
azsim = output(:,18)/32.2;
qsim  = output(:,8)*180/pi;
thetasim = output(:,5)*180/pi;

% Fix any initial bias
[azbias azsim] = fixbias(fdata(:,13),azsim);
[qbias qsim] = fixbias(fdata(:,6),qsim);
[thetabias thetasim] = fixbias(fdata(:,9),thetasim);

% Get the error bounds
aztrue = errorbounds(fdata(:,1),fdata(:,13),0.1);
qtrue = errorbounds(fdata(:,1),fdata(:,6),2);
thetatrue = errorbounds(fdata(:,1),fdata(:,9),1.5);

%% See if the test was passed or failed and thanks to what value

% See if the test failed
azflag    = compare(aztrue,azsim); 
qflag     = compare(qtrue,qsim);
thetaflag = compare(thetatrue,thetasim);

% Add FAILED to the title
if azflag == 1 || (qflag == 1 && thetaflag == 1)
    testname = strcat(testname,'_FAILED');
    
    if azflag ==1
        testname = strcat(testname,'_Az');
    end
    
    if qflag ==1
        testname = strcat(testname,'_q');
    end
    
    if thetaflag ==1
        testname = strcat(testname,'_Theta');
    end
    
end

%% Generate the plots and sub-reports
plotstate(fdata(:,1),aztrue,azsim,'az (g)','az',testname2)
plotstate(fdata(:,1),qtrue,qsim,'q (deg/s)','q',testname2)
plotstate(fdata(:,1),thetatrue,thetasim,'\theta (deg)','theta',testname2)

%% Merge all PDFs into one and delete the singles ones
testname = strcat(testname,'.pdf');
append_pdfs(testname,'az.pdf','q.pdf','theta.pdf');

% Delete figures and temporary files
delete('az.pdf','q.pdf','theta.pdf');
close all

