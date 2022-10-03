function [ S ] = computeS( r, sigma_d )
% Computes the close form solution. C.K. Tang et al., 2011
% 
% Note: R is 1x3 vector


% Normalize r
r = r/norm(r);

% Closed form solution
    c = exp( -( norm(r) ).^2 / sigma_d );
    R   = eye(3) - 2*r'*r;
    R_d = (eye(3) - 0.5*r'*r)*R;    
    S = c * R * eye(3) * R_d;

end

