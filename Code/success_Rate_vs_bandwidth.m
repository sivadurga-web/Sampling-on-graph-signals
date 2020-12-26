% This graph determines the success rate decreases as the bandwidth
% increases by checking the whether random sampling operator is a k ranked matrix
% or not. It is clear that when N value is high the success rate is also
% high as there is more probability to get set of independent vectors.

N = 1000;
A = randn(N,N).*2;
ii = 1:N;
for k=ii
    A(k,k)=0;
end
b = 1:20;

[v,d] = eig(A);  %v is eigenvector matrix, d is diagonal matrix

%sorting the eigenvalues in descending order to smoothen the graph
d1=diag(sort(diag(d),'descend')); % make diagonal matrix out of sorted diagonal values of input D
[c, ind]=sort(diag(d),'descend'); % store the indices of which columns the sorted eigenvalues come from
v1=v(:,ind); % arrange the columns in this order
d = d1;
v = v1;
arr = zeros(size(b)); %stores the success rate of each bandiwidth value
for jj = b
    M = jj;
    for kk = 1:100 % for every bandwidth we are testing 100 random sampling operators and count the no. of full ranked matrix in it.
        samp_oper2 = zeros(M,length(x));
        rand_samp = randi([1,N],jj,1);
        for ii = 1:M
            samp_oper2(ii,rand_samp(ii)) = 1;
        end
        if(rank(samp_oper2)==jj)
            arr(jj) = arr(jj)+1;
        end
    end
    arr(jj) = arr(jj)/100; %normalizing 
end
figure();
plot(b,arr);
ylim([0,1]);
title("Random sampling operator success rate");
xlabel("Bandwidth");
ylabel("Success rate");