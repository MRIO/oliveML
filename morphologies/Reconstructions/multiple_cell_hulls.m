
% requires:
% histcn (nd histogram)
% vol3d (volumetric display of densities)
% convVol (convolve volume - estimation of densities - my own)
% convhulln (convex hull in 3d -- better than matlab's DelaunayTri)
% ax = axescheck(varargin{:});


% what to plot
	plottracing = 1;
	plotsomata  = 1;

% these options should be mutually exclusive
	vertexcolordata_is_distancetoroot = 0;
	one_color_per_cell = 1;
	one_color_per_cell_no_edges = 0;
	no_alpha_info = 0;

% which cells to plot?
pathtocells = '/Users/M/Public/Dropbox/M-Yoe/swirl338/';
a  = dir('/Users/M/Public/Dropbox/M-Yoe/swirl338/*.swc')
selectedcells = [1:32];


KS = nan(length(selectedcells),2);

figure
colors = linspecer(32);
colors = colors(randperm(32),:);

for cellnumber = selectedcells

	try 
		cell1 = load_v3d_swc_file([ pathtocells num2str(cellnumber)  '.swc']);
		span = max(cell1(:,[3 4 5]))-min(cell1(:,[3 4 5]));
		coords = cell1(:,[3 4 5]);
		IO{cellnumber} = coords;

		% [================================================]
		%  calculation of the bounding volume
		% [================================================]

		
		CH{cellnumber} = convhulln(IO{cellnumber});



		% [================================================]
		% 		 Distances
		% [================================================]

		root = coords(1,:);
		cg   = mean(coords);
		
		Dcg{cellnumber} = squareform(pdist([cg ; [IO{cellnumber}(CH{cellnumber}(:,1),1) IO{cellnumber}(CH{cellnumber}(:,2),2) IO{cellnumber}(CH{cellnumber}(:,3),3) ]]));
		[h_cg x] = hist(Dcg{cellnumber}(1,:),20);
		
		Drt{cellnumber} = squareform(pdist([root ; [IO{cellnumber}(CH{cellnumber}(:,1),1) IO{cellnumber}(CH{cellnumber}(:,2),2) IO{cellnumber}(CH{cellnumber}(:,3),3) ]]));
		[h_rt ] = hist(Drt{cellnumber}(1,:),x);

		Drt_all{cellnumber} = squareform(pdist([root ; [IO{cellnumber}(:,1) IO{cellnumber}(:,2) IO{cellnumber}(:,3) ]]));
		
		
		dist_to_root_alpha = 1-Drt_all{cellnumber}(2:end,1)/ max(Drt_all{cellnumber}(2:end,1));
		
		
		% P{cellnumber} = trisurf( CH{cellnumber},IO{cellnumber}(:,1),IO{cellnumber}(:,2),IO{cellnumber}(:,3), ...
		% 	'Facecolor',colors(cellnumber,:),'edgecolor',[.8 .8 .8].*colors(cellnumber,:), 'FaceAlpha', 'interp', ...
		% 	'FaceVertexCData', Drt_all{cellnumber}(2:end,1), 'FaceVertexAlphaData', dist_to_root_alpha );
		hold on

			

		if vertexcolordata_is_distancetoroot
			P{cellnumber} = trisurf( CH{cellnumber},IO{cellnumber}(:,1),IO{cellnumber}(:,2),IO{cellnumber}(:,3), ...
				'edgecolor',[.8 .8 .8].*colors(cellnumber,:), 'FaceAlpha', 'interp', ...
				'FaceVertexCData', dist_to_root_alpha, 'FaceVertexAlphaData', dist_to_root_alpha );
			colormap(hot(30))

		elseif one_color_per_cell

			
			P{cellnumber} = trisurf( CH{cellnumber},IO{cellnumber}(:,1),IO{cellnumber}(:,2),IO{cellnumber}(:,3), ...
				'Facecolor', colors(cellnumber,:),'edgecolor',[.8 .8 .8].*colors(cellnumber,:), 'FaceAlpha', 'interp', ...
				'FaceVertexCData', [], 'FaceVertexAlphaData', dist_to_root_alpha );

		elseif one_color_per_cell_no_edges
			
			P{cellnumber} = trisurf( CH{cellnumber},IO{cellnumber}(:,1),IO{cellnumber}(:,2),IO{cellnumber}(:,3), ...
				'Facecolor', colors(cellnumber,:),'edgecolor','none', 'FaceAlpha', 'interp', ...
				'FaceVertexCData', [], 'FaceVertexAlphaData', dist_to_root_alpha );

		elseif no_alpha_info
			
			P{cellnumber} = trisurf( CH{cellnumber},IO{cellnumber}(:,1),IO{cellnumber}(:,2),IO{cellnumber}(:,3), ...
				'Facecolor', colors(cellnumber,:),'edgecolor',[.8 .8 .8].*colors(cellnumber,:) , 'FaceAlpha', .2);

		end
		
		

		view(30,45)
		% disp('Paused. Press something to continue.')
		% pause

		[ KS(cellnumber,1) KS(cellnumber,2)] = kstest2(Dcg{cellnumber}(1,:), Drt{cellnumber}(1,:));


	catch
		disp('skipping cell')
		% keyboard
		num2str(cellnumber)
	end

	
end

if vertexcolordata_is_distancetoroot
	shading interp
end

% [================================================]
% 		 plot traces ?
% [================================================]

if plottracing
	for cellnumber = selectedcells

		try 

			hold on, scatter3(IO{cellnumber}(:,1),IO{cellnumber}(:,2),IO{cellnumber}(:,3),20 ,colors(cellnumber,:), 'filled')
			
		catch
			disp('brokencell')
		end
	end

end

% [================================================]
% 		 plot somata ?
% [================================================]

if plotsomata
	for cellnumber = selectedcells

		try 

			
			hold on, scatter3(IO{cellnumber}(1,1),IO{cellnumber}(1,2),IO{cellnumber}(1,3),500 ,colors(cellnumber,:), 'filled')
		catch
			disp('brokencell')
		end
	end

end



% lightangle(-45,30)
% P{cellnumber}.FaceLighting = 'gouraud';
% P{cellnumber}.AmbientStrength = 0.3;
% P{cellnumber}.DiffuseStrength = 0.8;
% P{cellnumber}.SpecularStrength = 0.9;
% P{cellnumber}.SpecularExponent = 25;
% P{cellnumber}.BackFaceLighting = 'unlit';




axis equal
grid on