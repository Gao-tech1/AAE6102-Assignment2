function PL = compute_PL(Updated_mat, Detect_results)
    P_md = 1e-7;
    G = Updated_mat.G;
    W = Updated_mat.W;

    K = inv(G'*W*G)*G'*W;
    P = G*K;

    % Q = inv(G'*W*G);     % covariance matrix (with weight)
    % PRMS = sqrt(Q(1,1)+ Q(2,2)+ Q(3,3));  % combine both Horizontal and Vertical dimensions


    

    Nr_sat = sum(G(:,1) ~= 0);
    % abandon the weak geometry satellite --sbs

    for i = 1 : Nr_sat


        Pslope(i) = sqrt(sum((K(1:3,i)).^2)) * sqrt(1/W(i,i)) / sqrt(1-P(i,i));


            if abs(P(i,i)-1)<1e-4
                Pslope(i)= 0;
            end



    end
    % disp(Pslope)
    URA = 3;
    PL = max(Pslope) * Detect_results.Thres + norminv(1-P_md/2) * URA;
end
