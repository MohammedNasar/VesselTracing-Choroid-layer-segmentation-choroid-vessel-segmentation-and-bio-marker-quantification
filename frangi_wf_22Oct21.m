
function [fcvolFilt, scale] = frangi_wf_22Oct21(fcvol,r1,r2)
    options.BlackWhite = false;
    options.FrangiScaleRange = [r1 r2];
    tic
    [fcvolFilt, scale] = FrangiFilter3D(fcvol,options);
    toc
end
% fcvolFilt_imc=imclose(fcvolFilt,ones(3,3,3));
% scale_imc=imclose(scale,ones(3,3,3));
