

function [mnd, mcl_gd_pt] = sel_cp(nd,cl_gd_pt,dim,sVol)    
%     sVol
    ind = [];
    for ii = 1:length(nd)
        if ~(nnz(and(abs(nd(ii,:)) >= dim,abs(nd(ii,:)) <= sVol-dim)) == 3)
            ind = [ind;ii];
        end
    end
    mnd = nd;
    mnd(ind,:) = [];
    mcl_gd_pt = cl_gd_pt;
    mcl_gd_pt(ind,:) = [];
end
