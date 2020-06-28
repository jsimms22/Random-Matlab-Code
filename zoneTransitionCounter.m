clc;
clear;

% The variable "numberOfFiles" below here should reflect how many .txt files you have, 
% The rest of the code works based off this number
% If the files are labeled from 0 to X, then this should equal "X + 1"
% If the files are labeled from 1 to X, then this should equal "X"
numberOfFiles = 25;

% This will create an Object called mice, if you want to know how these work 
% generally look up object oriented programming (OOP), specifically classes
% or structs.
miceInputData = cell(numberOfFiles,1); 

% The for loop below iterates through all of the files that are of format
% //"Test" + "some number associated" + ".txt"//.
for k = 1:numberOfFiles
    fileName = sprintf('Test %d.txt', k);
    temp = importdata(fileName);
    miceInputData{k} = temp.data;
end

% /------------------------------------------------------------------------/

% DATA OVERVIEW= 
% DATA(fileNumber, 1) = Closed Arms -> Open Arms Count / 
% DATA(fileNumber, 2) = Open Arms -> Closed Arms Count / 
% DATA(fileNumber, 3) = NAN Total / 
% DATA(fileNumber, 4) = Length Of Data / 
% DATA(fileNumber, 5) = Transitions Count
data = zeros(25,4);

% /------------------------------------------------------------------------/

% I will not comment on the code below, because it is rather inefficient
% and the correct answer was found by trying to track something
% incorrectly. There is a simpler way (less lines of code) to track the 
% amount of transitions between open and closed arm zones, but hindsight if
% 20/20 and I was drunk when I started this code.

for k = 1:numberOfFiles
    temp = miceInputData{k};
    nanTotal = 0;
    for i = 1:length(temp)
        if (temp(i,3) == -1000 && temp(i,4) == -1000)
            nanTotal = nanTotal + 1;
        end
    end
    data(k,3) = nanTotal;
end

for k = 1:numberOfFiles
    temp = miceInputData{k};
    x = 2;
    timeInClosed = 1;
    timeInOpen = 1;
    didLoop = 0;
    for i = 1:length(temp)
        if x >= length(temp)
            break;
        end
        if (temp(x,3) == 1 )
           y = x;
           didLoop = 0;
           while temp(y,3) == temp(y-1,3)
               timeInClosed = timeInClosed + 1;
               y = y + 1;
               didLoop = 1;
               if y > length(temp)
                   break;
               end
               %For debugging
               %disp(y);
            end
            if didLoop == 1 
                x = y;
            end
        end
        if x > length(temp)
            break;
        end
        if (temp(x,4) == 1)
            y = x;
            didLoop = 0;
            while temp(y,4) == temp(y-1,4)
                timeInOpen = timeInOpen + 1;
                y = y + 1;
                didLoop = 1;
                if y > length(temp)
                    break;
                end
                % For debugging
                %disp(y);
            end
            if didLoop == 1
                x = y;
            end
        end
        if didLoop == 0
            x = x + 1;
            % For debugging
            %disp(x);
        end
    end
    data(k,4) = length(temp);
    data(k,5) = data(k,4) - (timeInClosed + timeInOpen + data(k,3));
end

% /------------------------------------------------------------------------/

for k = 1:numberOfFiles
    for i = 1:length(temp)
        if (temp(i,3) ~= -1000 || temp(i,4) ~= -1000)
            % Tells us if the mouse started in the closed arm zone first
            % then outputs how many times the mouse went from open to
            % closed and closed to open
            if (temp(i,3) == 1)
                data(k,1) = round(data(k,5) / 2);
                data(k,2) = data(k,5) - data(k,1);
            end
            % Tells us if the mouse started in the open arm zone first
            % then outputs how many times the mouse went from open to
            % closed and closed to open
            if (temp(i,4) == 1)
                data(k,2) = round(data(k,5) / 2);
                data(k,1) = data(k,5) - data(k,2);
            end
            % Once we know what zone a mouse started in, we move to the
            % next mouse
            break;
        end
    end
end

% /------------------------------------------------------------------------/

% File output loop
fileID = fopen('miceTransitionsCount.txt','w');
fprintf(fileID,'Mouse ID | Closed to Open | Open to Closed | Transition Count\n');
for k = 1:numberOfFiles
    fprintf(fileID,'%d    %d    %d    %d\n', k, data(k,1), data(k,2), data(k,5));
end
fclose(fileID);