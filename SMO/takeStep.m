function [value] = takeStep(i1,i2)
global Alpha threshold error C  num W K

eps = 0.1;
value = 0;

if(i1==12)
    return
end
alph1 = Alpha(1,i1);
alph2 = Alpha(1,i2);
y1 = num(i1,1);
y2 = num(i2,1);

E1 = svm_output(i1)- y1;
error(1,i1)= E1;
E2 = svm_output(i2)- y2;
s = y1*y2;
if(y1~=y2)
    L = max(0,alph2-alph1);
    H = min(C,C+(alph2-alph1));
else
    L = max(0,alph1+alph2-C);
    H = min(C,alph1+alph2);
end

if(L==H)
    return
end

%k11 = kernel(i1,i1);
%k12 = kernel(i1,i2);
%k22 = kernel(i2,i2);

eta = 2*K(1,2)-K(1,1)-K(2,2);
if(eta<0)
    a2 = alph2 - (y2*(E1-E2))/eta;
    if a2<L
        a2 = L;
    elseif a2>H
        a2 = H;
    end
else 
    % calculating objective function
    s = y1*y2;
    s_1 = y1*y1;
    s_2 = y2*y2;
    %k11 = kernel(i1,i1);
    %k12 = kernel(i1,i2);
    %k22 = kernel(i2,i2);
    a_1 = alph1*alph1;
    
    Lobj = (alph1+L)-(s_1*K(1,1)*a_1+2*s*K(1,2)*alph1*L+s_2*K(2,2)*L*L)/2;
    Hobj = (alph1+H)-(s_1*K(1,1)*a_1+2*s*K(1,2)*alph1*H+s_2*K(2,2)*H*H)/2;
    if Lobj > Hobj+eps
        a2 = L;
    elseif Lobj < Hobj-eps
        a2 = H;
    else
        a2 = alph2;
    end
end
const = eps;
if a2<const
    a2 = 0;
elseif a2>C-const
    a2 = C;
end

%if(abs(a2-alph2) < eps*(a2+alph2+eps))
if(abs(a2-alph2) < eps)
    return;
end
a1 = alph1+s*(alph2-a2);

threshold_1 = E1+y1*(a1-alph1)*K(i1,i1)+y2*(a2-alph2)*K(i1,i2)+threshold;
threshold_2 = E2+y1*(a1-alph1)*K(i1,i2)+y2*(a2-alph2)*K(i2,i2)+threshold;

if threshold_1 == threshold_2
    threshold_new= threshold_1;
else
    if a1>0 && a1<C
        threshold_new = threshold_1;
    elseif a2>0 && a2<C
        threshold_new = threshold_2;
    else
        threshold_new = (threshold_1+threshold_2)/2;
    end
end

W(1,:) = W(1,:)+(y1*(a1-alph1)*i1)+(y2+(a2-alph2)*i2);

non_zero_non_c = find(Alpha ~=0 & Alpha~=C);
for m=1:length(non_zero_non_c)
    error(m) = error(m)+y1*(a1-alph1)*kernel(i1,m)+y2*(a2-alph2)*kernel(i2,m)+threshold-threshold_new;
end
error(i2) = 0;
error(i1) = 0;
Alpha(i1)=a1;
Alpha(i2)=a2;
threshold = threshold_new;
value = 1;
return


