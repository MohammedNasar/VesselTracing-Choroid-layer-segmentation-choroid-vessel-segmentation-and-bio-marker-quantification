
function mat = pts2mtx(points)
% points=po0;
xmin = min(points(:,1));
xmax = max(points(:,1));
ymin = min(points(:,2));
ymax = max(points(:,2));
zmin = min(points(:,3));
zmax = max(points(:,3));
% Initialize output matrix in which a non-zero entry indicates a 3D point exists in the input set
mat = zeros(xmax-xmin+1, ymax-ymin+1, zmax-zmin+1);
% For all 3D points
for p=1:size(points, 1)
    if ( points(p,1)>xmax || points(p,1)<xmin || points(p,2)>ymax || points(p,2)<ymin || points(p,3)>zmax || points(p,3)<zmin )
        fprintf('Error: point %d is out of bounds.\n', p);
    else
        i = points(p,1) - xmin + 1;
        j = points(p,2) - ymin + 1;
        k = points(p,3) - zmin + 1;
%          i = points(p,1);
%         j = points(p,2);
%         k = points(p,3);
        mat(i, j, k) = 1;
    end
end