%Input the adjacency matrix and the corresponding graph signal
N = abs(round(rand(1)*10)*round(rand(1)*5));
if(N==0)
    disp("RUN AGAIN");
end
A = randn(N,N);
ii = 1:N;
for k=ii
    A(k,k)=0;
end
bandwidth = abs(floor(rand(1)*N));
x_hat = zeros(N,1);
x_hat(1:bandwidth) = randn(bandwidth,1);
%Computing the graph fourier transform of for the graph signal
%eigen values of the adjacency matrix , calculation

[v,d] = eig(A);  %v is eigenvector matrix, d is diagonal matrix

%sorting the eigenvalues in descending order to smoothen the graph
d1=diag(sort(diag(d),'descend')); % make diagonal matrix out of sorted diagonal values of input D
[c, ind]=sort(diag(d),'descend'); % store the indices of which columns the sorted eigenvalues come from
v1=v(:,ind); % arrange the columns in this order
d = d1;
v = v1;

v_inv =  v^(-1); %v_inv stores the inverse eigenvector matrix
x = v*x_hat;
%computes the graph fourier transform
x_hat = v_inv*x; %x_hat is GFT
ind_x =zeros(size(x_hat)); 

%Finding the bandwidth by finding the no. of  ~0 value in the x_hat
for ii=(1:length(x_hat))
    if (abs(x_hat(ii)) <0.01) % assuming the values less than this has less significance
        x_hat(ii) = 0;
        ind_x(ii) = 1;
    end
end

%% moving the zero values to end to make the signal band limited.
x_hat_new = zeros(size(x_hat));
v_inv_new = zeros(size(v_inv));
bandwidth = length(x)-sum(ind_x); %bandwidth of the signal
ind = 1;
rev_ind = bandwidth+1;
for ii=(1:length(x_hat))
    if(x_hat(ii)~=0 || rev_ind >length(x))
        x_hat_new(ind) = x_hat(ii);
        v_inv_new(:,ind)= v_inv(:,ii);
        ind = ind+1;
    else
        v_inv_new(:,rev_ind) = v_inv(:,ii);
        rev_ind = rev_ind+1;
    end
end


% finding the optimal sampling operator
v1 = v_inv_new^(-1);
M = bandwidth;  %here we are choosing the minimal sampling set
[optimal_v,optimal_ind] = optimal_sampling_operator(v_inv_new,M,length(x));
samp_oper1 = zeros(M,length(x));
samp_oper2 = zeros(M,length(x));
for ii = 1:M
    samp_oper1(ii,ii) = 1; % here we are using the first k linear independent rows. 
end
for ii = 1:M
    samp_oper2(ii,optimal_ind(ii)) = 1;
end



% interpolating operator

noise = 0;
e1 = [];
e2 = [];
for ii = 1:10
noise = noise + rand(1,N)./5;
inter_oper1 = v1(:,1:M)*((samp_oper1*v1(:,1:M))^(-1));
inter_oper2 = v1(:,1:M)*((samp_oper2*v1(:,1:M))^(-1));
x_samp1 = samp_oper1*(x+noise');
x_reconstruct1 = inter_oper1*x_samp1;
x_samp2 = samp_oper2*(x+noise');
x_reconstruct2 = inter_oper2*x_samp2;
e1 = [e1;max(abs(x_reconstruct1-x))];
e2 = [e2;max(abs(x_reconstruct2-x))];
end
figure();
plot(e1);
hold on;
plot(e2);
hold off;
legend("general(qualified) sampling operator","optimal sampling operator");
title("Absolute error between the reconstructed and original signal");
xlabel("noise increasing as the trail no. increases");
ylabel("error");