
% requires:
% histcn (nd histogram)
% vol3d (volumetric display of densities)
% convVol (convolve volume - estimation of densities - my own)
% convhulln (convex hull in 3d -- better than matlab's DelaunayTri)

cell1 = load_v3d_swc_file('JM418_S8_group1_C1_tippa_FULL.swc');
span = max(cell1(:,[3 4 5]))-min(cell1(:,[3 4 5]));
coords = cell1(:,[3 4 5]);
IO = coords;



% [================================================]
%  calculation of the bounding volume
% [================================================]

T = delaunay(IO(:,[1 2 3]);

CH = convhulln(IO);
clf
trisurf(CH,IO(:,1),IO(:,2),IO(:,3),'Facecolor','blue','FaceAlpha',0.5)
shading interp
colormap(hot(36))
hold on
trisurf(CH,IO(:,1),IO(:,2),IO(:,3),'Facecolor','blue','FaceAlpha',0.1,'edgecolor',[.8 .8 .8])
hold on, scatter3(IO(:,1),IO(:,2),IO(:,3),10 ,'filled')
hold on, scatter3(IO(1,1),IO(1,2),IO(1,3),500 ,'filled')

root = coords(1,:);
cg   = mean(coords);
Dcg = squareform(pdist([cg ; [IO(CH(:,1),1) IO(CH(:,2),2) IO(CH(:,3),3) ]]));
[h_cg x] = hist(Dcg(1,:),100);
Drt = squareform(pdist([cg ; [IO(CH(:,1),1) IO(CH(:,2),2) IO(CH(:,3),3) ]]));
[h_rt ] = hist(Drt(1,:),x);
bar([h_cg;h_rt]')

% [xx yy zz] = meshgrid(b{1},b{2},b{3});
% p1 = patch(isosurface(xx,yy,zz,permute(a,[2 1 3]),1));


% if we want an isosurface around the dendrites...
% binsize = 1;
% [a b c d ] = histcn(IO,round(span(1)/binsize),round(span(2)/binsize),round(span(3))/binsize);
% aaa = padarray(a, [1 1 1], 0,'both');
% isosurface(aaa, .05), axis equal;
% figure, isosurface(aaa, .05,'facealpha', .1), axis equal;



