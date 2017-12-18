
function [act g3d] = convVol(a, ks,alph)

	nn = 40;
	
	amplitude = 1;
	mu = ceil(ks/2);
	g3d = gaussKernel3d(alph, amplitude, ks, mu);

			% a = gpuArray(a);
			% g3d = gpuArray(g3d);

			act  = convn(a, g3d,'same' );
			
			


function g3d = gaussKernel3d(alph, amplitude, n, mu)
	[xx yy zz] = meshgrid([1:n],[1:n],[1:n]);
	gausskernel3d = @(x, y, z)(amplitude * exp(-((x-mu)^2 + (y-mu)^2 + (z-mu)^2)*alph));
	g3d = arrayfun(gausskernel3d, xx, yy, zz);
	g3d = g3d/sum(sum(sum(g3d)));


%%==========================================================     CONVOLVE VOLUME
