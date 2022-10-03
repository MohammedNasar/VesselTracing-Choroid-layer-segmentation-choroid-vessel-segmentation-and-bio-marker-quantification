

% dtype='AMD';
% dtype = 'CSCR';
% dtype='Healthy';
kywd = strr;
fpath = strcat('VT_GUI_data_new1\',date,'\',kywd);
mkdir(fpath);
save(strcat(fpath,'\Data.mat'),'CIB3D_Fill3','COB3D_Fill3','m_pt','mask','vol','enf_img','h5file');
% ,'c2','mat_fn'

