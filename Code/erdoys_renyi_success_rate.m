%erdyos graph for 

N1 = 100; % Number of nodes
N2 = 500; %Number of nodes
M =5;

connection_prob = 0.01:0.02:0.5;
arr1 = zeros(size(connection_prob));
arr2 = zeros(size(connection_prob));
ind =1;
for ii = connection_prob
    g1 = gsp_erdos_renyi(N1,ii);
    g2 = gsp_erdos_renyi(N2,ii);
    A1 = double(g1.W);
    A2 = double(g2.W);
    for jj = 1:100
        s1 = randi([1,N1],M,1);
        s2 = randi([1,N2],M,1);
        m1 = zeros(N1,N1);
        m2 = zeros(N2,N2);
        for kk = 1:M
            m1(kk,s1(kk)) = 1;
            m2(kk,s2(kk)) = 1;
        end
        if(rank(m1)==M)
            arr1(ind) = arr1(ind)+1;
        end
        if(rank(m2)==M)
            arr2(ind) = arr2(ind)+1;
        end
    end
    arr1(ind) =arr1(ind)/100;
    arr2(ind) = arr2(ind)/100;
    ind = ind+1;
end
figure();
plot(connection_prob,arr1);
hold on;
plot(connection_prob,arr2);
ylim([0,1]);
title("Erdoys success rate using sampling operator");
xlabel("connection probability");
ylabel("success rate");
hold off;