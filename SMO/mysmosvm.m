function mysmosvm(filename,numruns)
global Alpha threshold error C  num row column W K Y

num_final= csvread(filename);
%num = [-1 0 0;-1 1 1;1 2 0];
[row,column] = size(num_final);


for runs=1:numruns

run_time = cputime;
Alpha=zeros(1,row);
W=zeros(1,column);
error = zeros(1,row); % error-cache
num = num_final; % defining a new matrix to change the label
threshold = 0;

numChanged = 0;
examineAll = 1;
%remember to check the value for C
C = 2;
% converting the output to +1 and -1 for convinience

for i=1:row
    if num_final(i,1) == 3
        num(i,1) = 1;
    else
        num(i,1) = -1;
    end
end
% Calculation for kernel
if runs==1
K = zeros(row,row);
for ker_1=1:row
    for ker_2=1:row
        K(ker_1,ker_2)= kernel(ker_1,ker_2);
    end
end
% Calculation for output
Y = zeros(row,row);
for y_1=1:row
    for y_2=1:row
        Y(y_1,y_2)=num(y_1,1)*num(y_2,1);
    end
end
end
iter = 1;
while ((numChanged >0) || (examineAll)&& iter<10000)
    numChanged = 0;
    if(examineAll)
        for i=1:row 
            numChanged = numChanged+examineExample(i);
            if iter<=500
                objective(runs,iter) = objective_function();
            end
            iter = iter+1;
        end
    else
        for i=1:row
            if (Alpha(1,i)~=0) && (Alpha(1,i)~= C)
                numChanged = numChanged+examineExample(i);
                if iter<=500
                    objective(runs,iter) = objective_function();
                end
                iter = iter+1;
            end
        end
    end
    if examineAll == 1
        examineAll = 0;
    elseif numChanged == 0
        examineAll = 1;
    end
end
alpha =Alpha;
% used to take plot
dt = 1;
time = [1:dt:500]';
plot(time,objective(runs,1:500));
hold on;
e(runs) = cputime-run_time;
end
avg_time = mean(e)
std_deviation = std(e)
dlmwrite('tmp.txt',objective);

        
             