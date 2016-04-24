function [result]= svm_output(i)
global Alpha num threshold row W
%result = 0;
%for j=1:row
%    result = result+(num(j,1)*kernel(j,i)*Alpha(1,j));
%end
%result = result+threshold;
result = sum(W(1,:).*num(i,:))+threshold;
