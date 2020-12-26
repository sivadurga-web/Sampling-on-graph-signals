% This graph determines the success rate decreases as the bandwidth
% increases by checking the whether random sampling operator is a k ranked matrix
% or not. It is clear that when N value is high the success rate is also
% high as there is more probability to get set of independent vectors.

N = 100;
A = randn(N,N).*5;
ii = 1:N;
for k=ii
    A(k,k)=0;
end
samples = 1:20;
bandwidth = 2;
x_hat = zeros(N,1);
x_hat(1:bandwidth) = randn(bandwidth,1).*5;
[v,d] = eig(A);  %v is eigenvector matrix, d is diagonal matrix

%sorting the eigenvalues in descending order to smoothen the graph
d1=diag(sort(diag(d),'descend')); % make diagonal matrix out of sorted diagonal values of input D
[c, ind]=sort(diag(d),'descend'); % store the indices of which columns the sorted eigenvalues come from
v1=v(:,ind); % arrange the columns in this order

d = d1;
v = v1;
x = v*x_hat;
arr1 = zeros(size(samples));
arr2= zeros(size(samples)); %stores the success rate of each bandiwidth value
for jj = samples
    M = jj;
    for kk = 1:100 % for every bandwidth we are testing 100 random sampling operators and count the no. of full ranked matrix in it.
        samp_oper1 = zeros(M,N);
        samp_oper2 = zeros(M,N);
        [optimal_v,optimal_v_ind] =optimal_sampling_operator(v_inv,M,N);
        rand_samp = randi([1,N],jj,1);
        for ii = 1:M
            samp_oper2(ii,rand_samp(ii)) = 1;
            samp_oper1(ii,optimal_v_ind(ii)) = 1;
        end
        inter_oper1 = v(:,1:M)*((samp_oper1*v(:,1:M))^(-1));
        inter_oper2 = v(:,1:M)*((samp_oper2*v(:,1:M))^(-1));
        x_samp1 = samp_oper1*(x);
        x_reconstruct1 = inter_oper1*x_samp1;
        x_samp2 = samp_oper2*(x);
        x_reconstruct2 = inter_oper2*x_samp2;
        count1 = 0;
        count2 = 0;
        for ii = 1:N
            if(abs(x - x_reconstruct1)<0.001)
                count1 = count1+1;
            end
            if(abs(x-x_reconstruct2)<0.001)
                count2 = count2+1;
            end
        end
        if(count1 ==N)
            arr1(jj) = arr1(jj)+1;
        end
        if(count2 == N)
            arr2(jj) = arr2(jj)+1;
        end
    end
    arr1(jj) = arr1(jj)/100; %normalizing 
    arr2(jj) = arr2(jj)/100;
    
end
figure();
plot(b,arr1);
ylim([0,1]);
hold on;
plot(b,arr2);
title("optimal vs random sampling operator");
xlabel("# of samples");
ylabel("Success rate");
legend("optimal sampling operator","random sampling operator");
hold off;