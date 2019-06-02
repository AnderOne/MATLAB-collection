%Функция для двумерной аппроксимации с интервальными ограничениями, минимизирующей сумму квадратов вторых производных;
%Формулы взяты по ссылке:
%[А.А. Сухинов, "Восстановление донной поверхности по различным картографическим данным" // Вестник ЮУрГУ, №17(150), 2009]
function F = approximate(X, Y, F, nz, nt)

	minx = min(X(:)); maxx = max(X(:)); miny = min(Y(:)); maxy = max(Y(:)); numx = length(X); numy = length(Y);

	%Заполняем интервальные значения скалярного поля:
	minz = min(F(:)); maxz = max(F(:)); hz = (maxz - minz) / nz;
	MinF = hz * floor(F / hz);
	MaxF = hz + MinF;
	F = (MinF + MaxF) / 2;
	%Отрисовка скалярного поля:
	surfl(X, Y, F.');
	axis([minx, maxx, miny, maxy, minz, maxz]);
	title(['step: ', num2str(0)]);
	getframe();

	%Заполняем элементы матрицы:
	for ix = 1 : numx
	for iy = 1 : numy
		for l = - 2 : 2
			p = ix + l; if ((p < 1) || (p > numx)); Bx(3 + l) = 0; else Bx(3 + l) = 1; end
			p = iy + l; if ((p < 1) || (p > numy)); By(3 + l) = 0; else By(3 + l) = 1; end
		end
		Q(ix, iy,  1) =   2 * (Bx(1) + Bx(2) * Bx(4) + Bx(2) * By(2) + Bx(2) * By(4));
		Q(ix, iy,  2) =   2 * (Bx(5) + Bx(2) * Bx(4) + Bx(4) * By(2) + Bx(4) * By(4));
		Q(ix, iy,  3) =   2 * (By(1) + By(2) * By(4) + Bx(2) * By(2) + Bx(4) * By(2));
		Q(ix, iy,  4) =   2 * (By(5) + By(2) * By(4) + Bx(2) * By(4) + Bx(4) * By(4));
		Q(ix, iy,  5) = - 2 * (Bx(2) * By(2));
		Q(ix, iy,  6) = - 2 * (Bx(4) * By(2));
		Q(ix, iy,  7) = - 2 * (Bx(2) * By(4));
		Q(ix, iy,  8) = - 2 * (Bx(4) * By(4));
		Q(ix, iy,  9) = - Bx(1);
		Q(ix, iy, 10) = - Bx(5);
		Q(ix, iy, 11) = - By(1);
		Q(ix, iy, 12) = - By(5);
		Q(ix, iy, :) = Q(ix, iy, :) / sum(Q(ix, iy, :));
	end
	end
	%Итерационный процесс (метод Зейделя):
	SHIFTiX = [- 1, + 1,   0,   0, - 1, + 1, - 1, + 1, - 2, + 2,   0,   0];
	SHIFTiY = [  0,   0, - 1, + 1, - 1, - 1, + 1, + 1,   0,   0, - 2, + 2];
	for t = 1 : nt
		e = 0;
		for ix = 1 : numx
		for iy = 1 : numy
			S = 0;
			for l = 1 : 12
				ix1 = ix + SHIFTiX(l);
				iy1 = iy + SHIFTiY(l);
				if ((ix1 < 1) || (ix1 > numx) || (iy1 < 1) || (iy1 > numy))
					continue
				end
				S = S + Q(ix, iy, l) * F(ix1, iy1);
			end
			%Корректируем значения:
			S = max(MinF(ix, iy), min(MaxF(ix, iy), S));
			e = max(e, abs(S - F(ix, iy)));
			F(ix, iy) = S;
		end
		end
		%Отрисовка скалярного поля:
		surfl(X, Y, F.');
		axis([minx, maxx, miny, maxy, minz, maxz]);
		title(['step: ', num2str(t), '; ',...
		       'err = ', num2str(e)]);
		getframe();
		%Условие остановки:
		if (e < 1.e-4 * hz)
			break;
		end
	end
end
