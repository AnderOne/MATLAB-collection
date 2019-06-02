%Тест для двумерной аппроксимации с интервальными ограничениями, минимизирующей сумму квадратов вторых производных;
function F = test(nx, ny, nz, nt)

	xmin = - pi; xmax = pi; hx = (xmax - xmin) / (nx - 1);
	ymin = - pi; ymax = pi; hy = (ymax - ymin) / (ny - 1);
	X = xmin : hx : xmax;
	Y = ymin : hy : ymax;

	for ix = 1 : nx
	for iy = 1 : ny; F(ix, iy) = func(X(ix), Y(iy));
	end
	end
	F = approximate(X, Y, F, nz, nt);
end

%Функция скалярного поля:
function f = func(x, y)
	t = 10; z = 1 + 0.5 * abs(cos(0.5 * t));
	xt = - [x + z * sin(t), x - z * sin(t)];
	yt = - [y - z * cos(t), y + z * cos(t)];
	f = 0;
	for i = 1 : length(xt)
		r = sqrt(xt(i) * xt(i) + ...
		         yt(i) * yt(i));
		p = atan2(xt(i), yt(i));
		f = f - sin(p) * ...
		    w(r) * (-1) ^ i;
	end
end

function f = w(r)
	if (cosh(r) ~= 0)
		f = tanh(r) / (cosh(r) ^ 2);
	else
		f = 0;
	end
end

