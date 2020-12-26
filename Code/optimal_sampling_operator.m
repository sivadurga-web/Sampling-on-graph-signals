function [optimal_v,optimal_ind] = optimal_sampling_operator(v_inv,M,N)
v1 = v_inv^(-1);
optimal_vk = [];
optimal_ind = [];
curr_idx = 1;
check_already_used = zeros(N,1);

%The below loop maximises the minimum singular value of the set of
%independent of vectors used for sampling

while curr_idx <=M
    curr = 0;
    curr_i = 0;
    for i=1:N
        if check_already_used(i) ~=1
            singular_value = svds([optimal_vk;v1(i,1:M)],1,'smallest');
          %  singular_value
            if (curr < singular_value)
                curr = singular_value;
                curr_i = i;
            end
        end
    end
    if(curr_i==0)
        break;
    else
        check_already_used(curr_i) = 1;
        optimal_vk = [optimal_vk;v1(curr_i,1:M)];
        optimal_ind = [optimal_ind,curr_i];
        curr_idx = curr_idx + 1;
    end
end

optimal_ind = sort(optimal_ind);
optimal_v = v1((optimal_ind(1:length(optimal_ind))),1:M);

end