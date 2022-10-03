

function [mnd, mcl_gd_pt,dim]=sel_cp1(nd,cl_gd_pt,dim0,sVol)    
%     sVol
%     ind=[];
    for ii=1:length(nd)
        if ~(nnz(and(nd(ii,:)>=dim0,nd(ii,:)<=sVol-dim0))==3)
%             ind=[ind;ii];
            dim(ii)=dim0;
        else
            dim(ii)=dim0/2;
        end
    end
    mnd=nd;
%     mnd(ind,:)=[];
    mcl_gd_pt=cl_gd_pt;
%     mcl_gd_pt(ind,:)=[];
end
