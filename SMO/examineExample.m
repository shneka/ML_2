function [value] = examineExample(i2)
global Alpha error C  num row 

y2 = num(i2,1);
alph2 = Alpha(1,i2);
tol = 0.1;
E2 = svm_output(i2)-y2;
% error(1,i2)=E2;
r2 = E2*y2;
%choosing the second heuristic
value = 0;

if (r2<-tol && alph2<C) || (r2>tol && alph2>0)
    non_zero_non_c = find(Alpha ~=0 & Alpha~=C);
%     [~,index] = sort(error);
     if ~isempty(non_zero_non_c)
%         if E2>0
%             if index(1) == i2
%                 i1 = index(2);
%             else
%                 i1 = index(1);
%             end
%         elseif E2<0
%             if index(end) == i2
%                 i1 = index(end-1);
%             else 
%                 i1 = index(end);
%             end
%         end
        max_value=0;
        max_index=1;
        for i=1:length(error)
            if(abs(error(i)-E2) > max_value)
                max_value = abs(error(i)-E2);
                max_index = i;
            end
        end
        if takeStep(max_index,i2)
            value = 1;
            return;
        end
    rand_non = randperm(length(non_zero_non_c));
    for j=1:length(non_zero_non_c)
        if takeStep(rand_non(j),i2)
            value = 1;
            return ;
        end
    end
    end
    
    rand_full = randperm(row);
    for k=1:row
        if takeStep(rand_full(k),i2)
            value = 1;
            return
        end
    end
end
return
    
    
    

    
                  



