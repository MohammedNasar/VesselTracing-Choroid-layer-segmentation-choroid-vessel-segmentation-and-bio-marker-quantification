function pt = tensor_voting1( X, numOfNearestNeighbours, sigma_d )
pt=[];
for i=1:size(X,1)
    [IDX, D] = knnsearch(X, X(i,:), 'K', numOfNearestNeighbours+1 );    
    nn = X( IDX(2:end), : );
    xi_nn = repmat( X(i,:), numOfNearestNeighbours, 1 );
    r = (xi_nn - nn);
    S = zeros(3);
    for b=1:numOfNearestNeighbours
        S = S + computeS( r(b,:), sigma_d );
    end
    
    [V D] = eig(S);
    D = diag(D);
    [~, id] = min(D);  
    pt=[pt;X(i,:) V(:,id)'];
end
