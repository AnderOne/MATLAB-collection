%Function to save triangulation to a VTK-file format;
%Input:
%fname -- name of the output VTK-formatted file;
%C -- 2d-matrix whose rows contain indices of triangle vertices (start by 1);
%X -- X-coordinates of vertices;
%Y -- Y-coordinates of vertices;
%Z -- Z-coordinates of vertices;
%F -- scalar values on vertices.
function save_triangrid(fname, C, X, Y, Z, F)

	if (exist('Z'))
		nv = min([length(X(:)), length(Y(:)), length(Z(:))]);
	else
		nv = min([length(X(:)), length(Y(:))]);
		Z = zeros(nv, 1);
	end
	nc = length(C);

	fid = fopen(fname, 'wt');
	fprintf(fid, '# vtk DataFile Version 3.0\n');
	fprintf(fid, 'UNTITLED\n');
	fprintf(fid, 'ASCII\n');
	fprintf(fid, 'DATASET UNSTRUCTURED_GRID\n');
	fprintf(fid, 'POINTS %u double\n', nv);
	fprintf(fid, '%.15f\t%.15f\t%.15f\n', [X(:), Y(:), Z(:)].');
	fprintf(fid, 'CELLS %u %u\n', nc, 4 * nc);
	fprintf(fid, '3\t%u\t%u\t%u\n', C.' - 1);
	fprintf(fid, 'CELL_TYPES %u\n', nc);
	fprintf(fid, '%u\n', 5 * ones(1, nc));%VTK_TRIANGLE = 5
	if (~exist('F'))
		fclose(fid);
		return
	end
	fprintf(fid, 'POINT_DATA %u\n', nv);
	fprintf(fid, 'SCALARS ');
	fprintf(fid, 'scalar_field double 1\n');
	fprintf(fid, 'LOOKUP_TABLE ');
	fprintf(fid, 'default\n');
	fprintf(fid, '%.15f\n', F);
	fclose(fid);

end
