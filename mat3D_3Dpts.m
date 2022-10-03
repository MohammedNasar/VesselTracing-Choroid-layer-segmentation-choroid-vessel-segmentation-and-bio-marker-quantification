
function V=mat3D_3Dpts(Vas0)
    Vas=imbinarize(imfil_bin(Vas0));
    ind2 = find(Vas == 1);
    [V(:,1),V(:,2),V(:,3)] = ind2sub(size(Vas),ind2);
end