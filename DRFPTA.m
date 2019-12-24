%function [Theta, Phi] = DRFPTA(C, epsilon)
function achievedCurt = DRFPTA(C, epsilon)
%Inputs:
%The targeted curtailment value
%Desired Epsilon

%We will use 3 decimal point for precision e.g. 1000.000
precision = 10^3;
global num_strategies;
global num_intervals;
global num_buildings;

num_strategies = 6;
num_intervals = 16;

%Filename
filename = 'dataset\6by20.csv';
curtMatrix = readCurtMatrix(filename);

%Scale Values
Cp = C*precision;
curtMatrixp = curtMatrix*precision;

%Round values
[C_max, I] = max(curtMatrixp(:));
%C_max = C_max*num_intervals;
%if C_max > Cp
C_max = Cp;
%end
mu = epsilon*C_max/num_intervals/num_buildings;
Ccap = floor(Cp/mu);
curtMatrixcap = floor(curtMatrixp/mu);
%Ccap = ceil(Cp/mu);
%curtMatrixcap = ceil(curtMatrixp/mu);
%Strategy switching cost
cost = zeros(num_strategies, num_strategies); 
tau = 2;

C_max;
Ccap

%build1 = reshape(curtMatrixp(1,:,:), num_strategies, num_intervals);
disp 'Start filling Theta at: '
datestr(now, 'HH:MM:SS')
%Theta = zeros(num_buildings, Ccap, num_intervals, num_strategies, tau);
Theta = cell(num_buildings,1);
for b = 1:num_buildings
    %disp 'Filling table'
    %datestr(now, 'HH:MM:SS')
    %b
    Theta{b,1} = singleBuilding(Ccap, num_intervals, epsilon, tau, reshape(curtMatrixcap(b,:,:), num_strategies, num_intervals),cost);
end
disp 'End filling Theta at: '
datestr(now, 'HH:MM:SS')

size(Theta);
Theta;

achievedCurtArray = zeros(num_buildings, Ccap);

for i = 1:num_buildings
    for j = 1:Ccap+1
       achievedCurtArray(i,j) = max(Theta{i,1}(j,num_intervals,:,tau)); 
    end
end

achievedCurtArray(1,10);

disp 'Start combining buildings at: '
datestr(now, 'HH:MM:SS')
Phi = combineBuilding(Ccap,achievedCurtArray);
disp 'End combining buildings at: '
datestr(now, 'HH:MM:SS')

%max(Phi(10,num_buildings,:))

Curtailments = getBuildingCurtailments(Ccap, Phi, achievedCurtArray);

achievedCurt = 0;

for b = 1:num_buildings
   Strategies = getStrategies(Theta{b,1}, reshape(curtMatrixcap(b,:,:), num_strategies, num_intervals), Curtailments(b)); 
   
   if Strategies(1) > 0

    for i = 1:num_intervals
    achievedCurt = achievedCurt + curtMatrix(b,Strategies(i),i);
    end
   end
   
end

achievedCurt;

end

function curtMatrix = readCurtMatrix(filename)
    fileID = fopen(filename);   % open file "filename.csv"
    
    global num_strategies;
    global num_intervals;
    global num_buildings;
   % num_strategies = 6;
   % num_intervals = 16;
    
    %% Read the data into a matrix format
    if fileID>0 
        data = textscan(fileID,'%s');
        % close the file
        fclose(fileID);
    end

    num_buildings = length(data{:,1})/num_strategies;

    curtMatrix = zeros(num_buildings, num_strategies, num_intervals);
    for i = 1:num_buildings
        for j = 1:num_strategies
            lineNum = (i-1)*num_strategies + j;
            dailyCurt = strsplit(data{1,1}{lineNum},',');
            
            for k = 1:num_intervals
               curtMatrix(i,j,k) = str2double(dailyCurt(k)); 
            end
            
        end
    end
end


