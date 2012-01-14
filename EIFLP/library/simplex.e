note
	description: "A simplex algorithm."
	author: "Xiang Gao"
	date: "$Date$"
	revision: "$Revision$"

-- An eiffel implementation of simplex algorithm based on the CWEB version written by Prof. Knuth.

-- I'm writing this program in order to gain personal experience implementing the
-- simplex algorithm-even though I know that commercial codes do the job much, much better. My aim
-- is to learn, to make the logic "crystal clear" if not lightning fast, and perhaps also to watch and interact
-- with this magical process.
--                                                      Don. Knuth, 2005

-- Current version only supports maximization problem. The constraint type should be <=, and the bound of
-- any variable should be >= 0. Although it has many limitations, the main goal is "to learn and interact 
-- with this magical process" and it is not very difficult to extend to a more general and exact version.

class
	SIMPLEX

create
	make

feature {NONE}  -- Initialization

	make (model: MODEL)
		-- Transform the data from model.
		local
			i: INTEGER
			j: INTEGER
		do
			count := 0
			nrow := model.nrow
			ncol := model.ncol
			create rows.make_filled (0, nrow + 1, nrow + ncol + 1)
			create p.make_filled (0, 1, nrow + ncol + 1)
			create q.make_filled (0, 1, nrow + ncol + 1)

			from
				i := 1
			until
				i > nrow + 1
			loop
				from
					j := 1
				until
					j > ncol
				loop
					if i = 1 then
						rows.put (-model.rows.item (1, j), 1, 1 + nrow + j)
					else
						rows.put (model.rows.item (i, j), i, 1 + nrow + j)
					end
					j := j + 1
				end

				from
					j := 1
				until
					j > nrow
				loop
					if i = j + 1 then
						rows.put (1, i, j + 1)
					end
					j := j + 1
				end

				if i > 1 then
					rows.put (model.rh.item (i - 1), i, 1)
				end

				p[i] := i
				q[i] := i
				i := i + 1
			end
		end

feature -- Simplex.
	solve
		local
			i: INTEGER
			j: INTEGER
			l: INTEGER
			s: INTEGER
			h: INTEGER
			z: REAL_64
			eps: REAL_64
			inf: BOOLEAN
			trial: ARRAY[REAL_64]
		do
			inf := False
			eps := 0.0000001
			create trial.make_filled (0, 1, nrow + ncol + 1)

			from
				j := nrow + ncol + 1
			until
				j = 1 or inf
			loop
				if rows.item (1, j) < 0 then
					-- Try to pivot in column j
					l := 0
					from
						i := 2
					until
						i > nrow + 1
					loop
						if rows.item (i, j) > 0 then
							-- Consider pivoting at (i, j)
							if l = 0 then
								l := i
								s := 1
							else
								from
									h := 1
								until
									h > 1 and (trial.item (h - 1) - z).abs > eps
								loop
									if h = s then
										trial[s] := rows.item (l, h) / rows.item (l, j)
									end
									z := rows.item (i, h) / rows.item (i, j)
									h := h + 1
								end
								if trial.item(h - 1) > z then
									l := i
									trial.item (h - 1) := z
									s := h
								end
							end
						end
						i := i + 1
					end

					if l = 0 then
						io.put_string ("The maximum is infinite%N")
						inf := True
					end

					pivot (l, j)

					if verbose then
						print_tableaux
					end

					count := count + 1
					j := nrow + ncol + 1
				else
					j := j - 1
				end
			end
		end

	pivot (l: INTEGER; j: INTEGER)
		-- Do pivoting.
		local
			i: INTEGER
			k: INTEGER
			z: REAL_64
		do
			if verbose then
				io.put_string ("pivot at ")
				io.put_integer (l)
				io.put_string (" ")
				io.put_integer (j)
				io.new_line
			end

			from
				k := 1
				z := rows[l, j]
			until
				k > nrow + ncol + 1
			loop
				if rows[l, k] /= 0 then
					rows[l, k] := rows[l, k] / z
				end
				k := k + 1
			end

			from
				i := 1
			until
				i > nrow + 1
			loop
				if i /= l then
					from
						k := 1
						z := rows[i, j]
					until
						k > nrow + ncol + 1
					loop
						if k = j then
							rows[i, k] := 0
						else
							rows[i, k] := rows[i, k] - z * rows[l, k]
						end
						k := k + 1
					end
				end
				i := i + 1
			end

			q[p[l]] := 0
			p[l] := j
			q[j] := l
		end

feature -- Print

	print_tableaux
		-- Print the tableaux.
		local
			i: INTEGER
			j: INTEGER
		do
			from
				i := 1
			until
				i > nrow + 1
			loop
				from
					j := 1
				until
					j > nrow + ncol + 1
				loop
					io.put_double (rows.item (i, j))
					io.put_string (" ")
					j := j + 1
				end
				io.new_line
				i := i + 1
			end
			io.new_line
		end

	print_dim
		-- Print the number of rows and columns.
		do
			io.put_string ("nrow ")
			io.put_integer (nrow)
			io.new_line
			io.put_string ("ncol ")
			io.put_integer (ncol)
			io.new_line
		end

	print_optimal
		-- Print optimal objective value.
		local
			i: INTEGER
		do
			io.put_string ("Objective is ")
			io.put_double (rows[1, 1])
			io.new_line
			io.put_string ("Optimal is%N")

			from
				i := 2
			until
				i > nrow + 1
			loop
				io.put_string ("x")
				io.put_integer (i - 1)
				io.put_string (" = ")
				io.put_double (rows[1, i])
				io.new_line
				i := i + 1
			end
		end

feature -- Access

	nrow: INTEGER

	ncol: INTEGER

	rows: ARRAY2[REAL_64]

	p: ARRAY[INTEGER]

	q: ARRAY[INTEGER]

	count: INTEGER

	verbose: BOOLEAN = True
end
