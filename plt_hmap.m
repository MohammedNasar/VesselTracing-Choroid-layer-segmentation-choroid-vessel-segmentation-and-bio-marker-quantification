
figure;
% plt=
pcshow(pcCS);
% set(gca,'Font','B','FontSize',20)
ax = gca
ax.FontSize=14;
% ax.XColor=[1 1 0];
% ax.YColor=[1 1 0];
% ax.ZColor=[1 1 0];
% plt.Color=[1 1 1];
% t=title(str1{4});
% t.FontSize=16;
% caxis([minx, maxx]);
% caxis([h2(1), h2(end)]);
% c=colorbar();
% c = colorbar;
% c.Direction='normal';

c = hot;
c = flipud(c);
colormap(c);
c1 = colorbar;
% c.Label.String = 'My Colorbar Label';
c1.FontSize = 15;
c1.Color=[1 1 1];
% caxis([min(cx) max(cx)])
% caxis([lb ub])
caxis([0.02 0.2])
view(90,0);