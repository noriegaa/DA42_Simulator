function [X_T,U_T,status] = efrc_trim(modelname,X0,U)
% EFRC_TRIM Trims the aircraft in modelname longitudinal using a specified
% throttle setting for the specified altitude. Returns the trim states and
% the trim controls in the same order of input. The order is:
%
% X0 = [initu initv initw initbank initpitch inithead initp initq initr initnorth initeast initalt]
% U  = [elevator aileron rudder throttle]
%
% X_T    = States for trim
% U_T    = Controls for trim
% Status = 0/1                  (trimmed/not trimmed)
%
% Created: 06/11/12
% By: Alfonso Noriega

%% Create the operating point specification object.
opspec = operspec(modelname);

% Find the states. Only for inhouse 6DoF!!!
for p = 1:length(opspec.States)
    stop = 0;
    for i = length(opspec.States(p).Block):-1:1
        if strcmp(opspec.States(p).Block(i),'/')&&stop~=1

            statenames{p,1} = opspec.States(p).Block((i+1):end);

            stop = 1;
        end
    end
end



%% Set the constraints on the states in the model.
% - The defaults for all states are Known = false, SteadyState = true,
%   Min = -Inf, and Max = Inf.

%% Altitude:
indexC = strfind(statenames,'Alt');
alt = find(not(cellfun('isempty', indexC)));
opspec.States(alt).x = X0(12);
opspec.States(alt).Known = true;

%% East
indexC = strfind(statenames,'East');
east = find(not(cellfun('isempty', indexC)));
opspec.States(east).x = X0(11);

%% North
indexC = strfind(statenames,'North');
north = find(not(cellfun('isempty', indexC)));
opspec.States(north).x = X0(10);
opspec.States(north).SteadyState = false;

%% U
indexC = strfind(statenames,'u integrate');
u = find(not(cellfun('isempty', indexC)));
opspec.States(u).x = X0(1);
opspec.States(u).Known = true;

%% V
indexC = strfind(statenames,'v integrate');
v = find(not(cellfun('isempty', indexC)));
opspec.States(v).x = X0(2);

%% W
indexC = strfind(statenames,'w integrate');
w = find(not(cellfun('isempty', indexC)));
opspec.States(w).x = X0(3);

%% Bank
indexC = strfind(statenames,'bank');
bank = find(not(cellfun('isempty', indexC)));
opspec.States(bank).x = X0(4);

%% Heading
indexC = strfind(statenames,'heading');
head = find(not(cellfun('isempty', indexC)));
opspec.States(head).x = X0(6);

%% Pitch
indexC = strfind(statenames,'pitch');
pitch = find(not(cellfun('isempty', indexC)));
opspec.States(pitch).x = X0(5);

%% P
indexC = strfind(statenames,'p integrate');
p = find(not(cellfun('isempty', indexC)));
opspec.States(p).Known = true;
opspec.States(p).x = X0(7);

%% Q
indexC = strfind(statenames,'q integrate');
q = find(not(cellfun('isempty', indexC)));
opspec.States(q).Known = true;
opspec.States(q).x = X0(8);

%% R
indexC = strfind(statenames,'r integrate');
r = find(not(cellfun('isempty', indexC)));
opspec.States(r).x = X0(9);
opspec.States(r).Known = true;


%% Set the constraints on the inputs in the model.
% - The defaults for all inputs are Known = false, Min = -Inf, and
% Max = Inf.

% Input (1) - Navion_Trim/Elevator
opspec.Inputs(1).u = U(1);

% Input (2) - Navion_Trim/Aileron
opspec.Inputs(2).u = U(2);

% Input (3) - Navion_Trim/Rudder
opspec.Inputs(3).u = U(3);

% Input (3) - Navion_Trim/Throttle
opspec.Inputs(4).u = U(4);
%opspec.Inputs(4).Known = true;

%% Create the options
opt = linoptions('DisplayReport','off');

%% Perform the operating point search.
[opspec,opreport] = findop(modelname,opspec,opt);


if strcmp(opreport.TerminationString,'Operating point specifications were successfully met.')
    fprintf('Trim Successful.\n')
    status = 0;
else
    fprintf('Warning: Trim Unsuccessful.\n')
    status = 1;
end

%% Make very small numbers zeros

for i = 1:12
    if abs(opspec.States(i).x)<1e-3
        opspec.States(i).x = 0;
    end
end

for i = 1:4
    if abs(opspec.Inputs(i).u)<1e-3
        opspec.Inputs(i).u = 0;
    end
end

X_T = [opspec.States(u).x opspec.States(v).x opspec.States(w).x opspec.States(bank).x opspec.States(pitch).x opspec.States(head).x opspec.States(p).x opspec.States(q).x opspec.States(r).x opspec.States(north).x opspec.States(east).x opspec.States(alt).x];
U_T = [opspec.Input(1).u opspec.Input(2).u opspec.Input(3).u opspec.Input(4).u];
