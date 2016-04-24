function mysgdsvm(filename,k,numruns)
num_test = csvread(filename);
[row,column] = size(num_test);
num = num_test;
for i=1:row
    if(num_test(i,1)==3)
        num(i,1) = -1;
    end
end

sorted_num = sortrows(num,1);
[~,~,uniqueIndex] = unique(sorted_num(:,1));  
cellA = mat2cell(sorted_num,accumarray(uniqueIndex(:),1),column);
M_1 = cellA{1,1};
M_3 = cellA{2,1};
lambda = 2;
T = 10000;
objective = zeros(numruns,T);

w = zeros(1,column-1);
%dt = 1;
%time = [1:dt:T]';

for runs= 1:numruns
run_time = cputime;
for t=1:T
% checking for the end conditions
if k ==1
  sample(filename,k,numruns);
  return
elseif k == 2000
        k1 = size(M_1,1);
        k2 = size(M_3,1);
else
k1 = int64(k/2);
k2 = k-k1;
end

rand_M_1 = M_1(randperm(size(M_1,1)),:);
rand_M_3 = M_3(randperm(size(M_3,1)),:);
%A_t = vertcat(rand_M_1,rand_M_3);
X_at = vertcat(rand_M_1(1:k1,2:column),rand_M_3(1:k2,2:column));
Y_at = vertcat(rand_M_1(1:k1,1),rand_M_3(1:k2,1));
flag = 0;
for i=1:size(X_at,1)
    if (Y_at(i,1)*dot(w,X_at(i,:))<1)
        if flag == 0
            X_atp = X_at(i,:);
            Y_atp = Y_at(i,1);
            flag = 1;
        else
            X_atp = vertcat(X_atp,X_at(i,:));
            Y_atp = vertcat(Y_atp,Y_at(i,1));
        end
    end
end
eta_t = 1.0/(lambda*t);
const_1 = (1-eta_t*lambda);
const_2 = (eta_t)/double(k);

w_half = const_1.*w;
for j=1:size(X_atp,1)
    w_half = w_half+(const_2*Y_atp(j,1))*X_atp(j,:);
end
w_new = min(1,(1.0/(sqrt(lambda)*norm(w_half))))*w_half;
if norm(w_new-w)<0.1
    break;
end
w = w_new;

fin = 0;
for p=1:size(X_at,1)
   dot(w,X_at(p,:));
   fin = fin+max(0,1-(Y_at(p,1)*dot(w,X_at(p,:))));
end
objective(runs,t) =((lambda/2.0)*(norm(w)^2))+(1/k)*fin;
end
dt = 1;
time = [1:dt:t]';
plot(time,objective(runs,1:t));
hold on
e(runs) = cputime-run_time;
% if runs==1
% fileId = fopen('tmp.txt','w');
% fprintf(fileId,objective(runs,1:t));
% else
% fileId = fopen('tmp.txt','at');
% fprintf(fileId,objective(runs,1:t));
% end
end
avg_time = mean(e)
std_deviation = std(e)
dlmwrite('tmp.txt', objective);

    


