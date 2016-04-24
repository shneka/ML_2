function [objective] = objective_function()
global Alpha row K Y

sum_alph = 0;
for i = 1:row
    sum_alph = sum_alph+Alpha(1,i);
end
A = zeros(row,row);
for a_1=1:row
    for a_2=1:row
        A(a_1,a_2)=Alpha(1,a_1)*Alpha(1,a_2);
    end
end

alph_2 = sum(sum(Y*K*A),2);
objective = sum_alph - alph_2/2;