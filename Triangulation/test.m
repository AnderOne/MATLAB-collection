function test()

	[C, X, Y] = rand_triangrid('CIRC', [-pi, pi, -pi, pi], 2000);
	%draw_triangrid(C, X, Y);
	F = sin(X - Y).* cos(X + Y);

	save_triangrid(...
	'test.vtk', C, X, Y, F, F...
	)

end
