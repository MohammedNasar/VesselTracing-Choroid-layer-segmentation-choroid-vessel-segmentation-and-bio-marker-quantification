
var = [];
for j = 1:size(m_pt,1)
    temp = reshape(m_pt(j,5:end),3,[])';
    temp(~any(temp,2), : ) = [];
    var = [var; temp repmat(m_pt(j,1),size(temp,1),1)];
end
% first three columns refer to the boundary voxels of the fitted circle and
% 4th column refers to its corresponding radius

hist_wf_10bins  % script for plotting CS histogram.
plt_hmap % script for plotting CS heatmap.


