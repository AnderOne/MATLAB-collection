%Function to make random delaunay triangulation;
%Output:
%C -- 2d-matrix whose rows contain indices of triangle vertices (start by 1);
%X -- X-coordinates of vertices;
%Y -- Y-coordinates of vertices;
%Input:
%ind -- text identifier defining strategy for a generator;
%lim -- [xmin, xmax, ymin, ymax];
%num -- desired number of points;
function [C, X, Y] = rand_triangrid(ind, lim, num)

	xmin = lim(1); xmax = lim(2); xlen = xmax - xmin; xmid = xmin + xlen / 2;
	ymin = lim(3); ymax = lim(4); ylen = ymax - ymin; ymid = ymin + ylen / 2;

	switch ind

	case {'RECT'}
		n = floor(sqrt(num) / 4); X = []; Y = [];
		if n > 0
			X = [0 : n - 1, n * ones(1, n), 1 : n, zeros(1, n)].';
			Y = [n * ones(1, n), 1 : n, zeros(1, n), 0 : n - 1].';
			X = xmin + xlen * X / n;
			Y = ymin + ylen * Y / n;
		end
		n = num - n;
		if n > 0
			X = [X; xmin + xlen * rand(n, 1)];
			Y = [Y; ymin + ylen * rand(n, 1)];
		end

	case {'CIRC'}
		n = floor(sqrt(num));
		r = 0.5 * min(xlen, ylen); p = 2 * pi / (n - 1) * [1 : n];
		X = r * cos(p).';
		Y = r * sin(p).';
		n = num - n;
		if n > 0
			r = r * sqrt(rand(n, 1));
			p = 2 * pi * rand(n, 1);
			X = [X; r.* cos(p)];
			Y = [Y; r.* sin(p)];
		end
		q = min(xlen, ylen);
		X = xmid + (xlen / q) * X;
		Y = ymid + (ylen / q) * Y;
	otherwise
		error('Unknown generator strategy!')
	end

	P = unique([X, Y], 'first', 'rows');
	X = P(:, 1);
	Y = P(:, 2);

	n = randperm(length(X));
	X = X(n);
	Y = Y(n);
	C = delaunay(X, Y);

end
