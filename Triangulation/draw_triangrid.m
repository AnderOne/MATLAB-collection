%Function to draw triangulation;
%Input:
%C -- 2d-matrix whose rows contain indices of triangle vertices (start by 1);
%X -- X-coordinates of vertices;
%Y -- Y-coordinates of vertices;
function draw_triangrid(C, X, Y)

	triplot(C, X, Y, 'r');
	hold on
	plot(X, Y, 'Color', 'b', 'LineStyle', 'none', 'Marker', '.');
	hold off
end
