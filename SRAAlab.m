clc; % Clears the Command Terminal below
clear; % Clears any saved variables - not clearing variables //can// cause issues

% /------------------------------------------------------------------------/

% The variable "numberOfFiles" below here should reflect how many .txt files you have, 
% The rest of the code works based off this number
% If the files are labeled from 0 to X, then this should equal "X + 1"
% If the files are labeled from 1 to X, then this should equal "X"
numberOfFiles = 25; 

% /------------------------------------------------------------------------/

% This will create an Object called mice, if you want to know how these work 
% generally look up object oriented programming (OOP), specifically classes
% or structs.
% Alternatively type "doc cell" in the terminal window below and Matlab
% will bring up their documentation on the function cell().
miceInputData = cell(numberOfFiles,1); 

% /------------------------------------------------------------------------/

% Next three lines are just initiallizing three variables to save the data
% we want. The command zeros(x,y) just initializes a matrix/array of x rows
% and y columns long and prefills the entire matrix with zeros.
closedTimeTotal = zeros(numberOfFiles,1); 
openTimeTotal = zeros(numberOfFiles,1);
timeTotal = zeros(numberOfFiles,1);

% /------------------------------------------------------------------------/

% The for loop below iterates through all of the files that are of format
% //"Test" + "some number associated" + ".txt"//.
% The data files must be in the same folder as this code
% Change the variable at the top named "numberOfFiles" to expand how many
% files or what number of files you are interested in.
% The way this is programmed all files you want to view must be labeled in
% sequential numerical order. For example, 4,5,6,....,X.
% In order change the sequence of targeted data files you can iterate by 2s
% or some other iterater by changing line 37 to be:
%           for k = 1:2:numberOfFiles
% That will look at Test 1, Test 3, Test 5,...., Test numberOfFiles
% If you try to import a file that does not exist it will throw an error
for k = 1:numberOfFiles
    fileName = sprintf('Test %d.txt', k);
    temp = importdata(fileName);
    miceInputData{k} = temp.data;
end

% /------------------------------------------------------------------------/

% The next code section below sums whenever a mouse is in either closed or
% open arms then saves the code in a row of the matrices associated with
% the file name: Test 1.txt will always be in row 1 of the variables
% "closedTimeTotal", "openTimeTotal", and "timeTotal". Same with row 2, 3
% and so on. "timeTotal" is the sum of closed and open times to see the 
% total time for the experiment.
for k = 1:numberOfFiles
    temp = miceInputData{k};
    for i = 1:length(temp)
        if(temp(i,3) == 1)
            closedTimeTotal(k) = closedTimeTotal(k) + 1;
        end
        if(temp(i,4) == 1)
            openTimeTotal(k) = openTimeTotal(k) + 1;
        end
    end
end

% we multiply by .04 because it is the length of time between samples in the raw data.
% The . in front of the * indicates we want to multiple every value in the
% matrix by the number that follows. It keeps from need another for loop.
openTimeTotal = openTimeTotal .* .04; 
closedTimeTotal = closedTimeTotal .* .04;

timeTotal = openTimeTotal + closedTimeTotal;

% /------------------------------------------------------------------------/

% Everything below imports the numbers collected above into a single matrix
% then creates a .txt file to save the output data into a file for later use.

miceOutputData = zeros(25,3);
miceOutputData(:,1) = closedTimeTotal;
miceOutputData(:,2) = openTimeTotal;
miceOutputData(:,3) = timeTotal;

% If you want the .txt to have a different name to meet a lab specific naming
% convention then change miceOutputData.txt to something else in the
% following line.
fileID = fopen('miceOutputData.txt','w');
fprintf(fileID,'Closed Arm    Open Arm    Total Time\n');
for i = 1:numberOfFiles
    fprintf(fileID,'%f    %f    %f\n', miceOutputData(i,1), miceOutputData(i,2), miceOutputData(i,3));
end
fclose(fileID);




