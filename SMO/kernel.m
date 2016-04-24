function [val_kernel]=kernel(j,i)
global num 
sigma = 10;
inter = norm(num(j,:)-num(i,:))^2;
val_kernel = exp(-inter/(2*sigma^2));
