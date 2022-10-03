
% close all;
% 
var(~any(var(:,4),2),:) = [];
cx = var(:,4);

figure; 
ax = gca
ax.FontSize=14;
hold on;
h=histogram(cx,10);
% title('Histogram')
xlabel('CS radius (mm)');
ylabel('Count in the order of Kilo (K)')
% zlabel('Percentage (%)')
set(gca,'FontSize',15)



bin_limits=h.BinLimits;
% disp('lower_limit=',bin_limits(1));
% sprintf('lower_limit = %03d\n', bin_limits(1));
sprintf('lower_limit =  %f...\n',bin_limits(1))
sprintf('Upper_limit =  %f...',bin_limits(2))
% prompt='Enter lower bound value: ';
% lb=input(prompt);
% prompt2='Enter upper bound value: ';
% ub=input(prompt2);
if ~exist('lb') & ~exist('ub')
    lb=bin_limits(1);
    ub=bin_limits(2);
end
clear filt_cond;
filt_cond=or(cx<lb,cx>ub);
cx(filt_cond)=[];
C = colormap(flipud(hot(256)));
len = size(C,1);
Gs = round(interp1(linspace(min(cx), max(cx),len),1:len,cx,'linear','extrap'));
x_rgb = C(Gs,:);
ccord = var(:,1:3);
ccord(filt_cond,:) = [];
pcCS = pointCloud(ccord,'Color', x_rgb); 
% pcwrite(pcCS,'8_CSCR_P841573204.ply')

% [min(cx) max(cx) mean(cx) mode(cx)]

% figure;
% fill3(ccord(:,1),ccord(:,2),ccord(:,3));% Gs);

