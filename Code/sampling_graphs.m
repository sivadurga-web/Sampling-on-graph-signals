% This program does sampling on graphs, and outputs the sampling and
% interpolating operator for the given graph signal

% This program tries to find the bandwidth of the corresponding graph
% signal by finding the graph fourier transform and then do sampling and
% interpolating operator
clc;
clear;

%Input the adjacency matrix and the corresponding graph signal

A = input("Enter the weight matrix");
x = input("Enter the signal in the form of a matrix");

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


%% finding the optimal sampling operator
v1 = v_inv_new^(-1);
M = bandwidth;  %here we are choosing the minimal sampling set
samp_oper = zeros(M,length(x));
[optimal_v,optimal_ind] = optimal_sampling_operator(v_inv_new,M,length(x));

for ii = 1:M
    samp_oper(ii,optimal_ind(ii)) = 1;
end



%% interpolating operator
inter_oper = v1(:,1:M)*((samp_oper*v1(:,1:M))^(-1));
x_samp = samp_oper*(x);
x_reconstruct = inter_oper*x_samp;



%% printing values
disp("sampling operator");
disp(samp_oper);
disp("sampled signal");
disp(x_samp);
disp("Interpolating operator");
disp(inter_oper);
disp("Reconstructed signal");
disp(x_reconstruct);

%% plotting is done using  gft toolbox

%plotting the input graph signal
N = length(x);
g_original =gsp_graph(A,[(cos((0:N-1)*(2*pi)/N))',(sin((0:N-1)*(2*pi)/N))']);
param.bar = 1;
param.bar_width = 1;

figure();
gsp_plot_signal(g_original,x,param);
title('original signal');

figure();
g_sampled = gsp_graph(A,[(cos((0:N-1)*(2*pi)/N))',(sin((0:N-1)*(2*pi)/N))']);
sie_samp = zeros(N,N);
for ii = 1:M
    sie_samp(optimal_ind(ii),optimal_ind(ii)) = 1;
end
x_samp = sie_samp*x;
title("sampled signal");
gsp_plot_signal(g_sampled,x_samp,param);
figure();
title("Reconstructed signal");
gsp_plot_signal(g_original,x_reconstruct,param);