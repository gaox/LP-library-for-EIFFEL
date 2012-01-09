note
	description: "Model for the LP problem."
	author: "Xiang Gao"
	date: "$Date$"
	revision: "$Revision$"

class
	MODEL

inherit
	ANY
		redefine
			is_equal
		end

create
	make

feature {NONE}  -- Initialization

	make (lp: POINTER; lib: LPLIB)

		local
			-- Access
			row_p: MANAGED_POINTER

			-- Misc
			i: INTEGER
			j: INTEGER
			tie: INTEGER
		do
			nrow := lib.lp_get_nrows (lp)
			ncol := lib.lp_get_ncolumns (lp)
			create rows.make_filled(0, nrow + 1, ncol)
			create rh.make_filled (0, 1, nrow)
			create const_type.make_filled (0, 1, nrow)
			create lowbo.make_filled(0, 1, ncol)
			create upbo.make_filled (0, 1, ncol)
			create is_int.make_filled (0, 1, ncol)
			create is_binary.make_filled (0, 1, ncol)

			create row_p.make (8 * (ncol + 1))

			is_maxim := lib.lp_is_maxim (lp)

			from
				i := 0
			until
				i > nrow
			loop
				-- Get right hand side and constraint type
				if i > 0 then
					rh.put (lib.lp_get_rh (lp, i), i)
					const_type.put (lib.lp_get_constr_type (lp, i), i)
				end

				-- Get constraint
				tie := lib.lp_get_row (lp, i, row_p.item)
				from
					j := 1
				until
					j > ncol
				loop
					rows.put (row_p.read_real_64 (0 + j * 8), i + 1, j)
					j := j + 1
				end
				i := i + 1
			end

			-- Get variable bounds
			from
				i := 1
			until
				i > ncol
			loop
				lowbo.put (lib.lp_get_lowbo (lp, i), i)
				upbo.put (lib.lp_get_upbo (lp, i), i)
				is_int.put (lib.lp_is_int (lp, i), i)
				is_binary.put (lib.lp_is_binary (lp, i), i)
				i := i + 1
			end
		end

feature -- Solve

	solve (lp: POINTER; lib: LPLIB)
		-- Construct solution
		do
			create sol.make (lp, lib)
		end

feature -- Compare

	is_equal (other: like Current): BOOLEAN
		-- Is the the tow models equal?
		do
			if rows.is_equal (other.rows) and then
			   const_type.is_equal (other.const_type) and then
			   lowbo.is_equal (other.lowbo) and then
			   upbo.is_equal (other.upbo) and then
			   is_int.is_equal (other.is_int) and then
			   is_binary.is_equal (other.is_binary) and then
			   is_maxim = other.is_maxim
			then
			   	Result := True
			else
				Result := False
			end
		end

feature -- Print

	print_const
		-- Print constraints and bounds of variables.
		local
			i: INTEGER
			j: INTEGER
		do
			-- Print constraints
			io.put_string ("Constraints:%N")
			from
				i := 1
			until
				i > nrow
			loop
				from
					j := 1
				until
					j > ncol
				loop
					io.put_double (rows.item (i + 1, j))
					io.put_string (" * x")
					io.put_integer (j)
					if j < ncol then
						io.put_string (" + ")
					end
					j := j + 1
				end
				if const_type.item (i) = 1 then
					io.put_string (" <= ")
				elseif const_type.item (i) = 2 then
					io.put_string (" >= ")
				else
					io.put_string (" = ")
				end
				io.put_double (rh.item (i))
				io.new_line
				i := i + 1
			end

			-- Print bounds on variables
			from
				i := 1
			until
				i > ncol
			loop
				io.put_double (lowbo.item (i))
				io.put_string (" <= x")
				io.put_integer (i)
				io.put_string (" <= ")
				io.put_double (upbo.item (i))
				io.new_line
				i := i + 1
			end

			-- Print if variable is integer
			from
				i := 1
			until
				i > ncol
			loop
				if is_int.item (i) = 1 then
					io.put_string ("x")
					io.put_integer (i)
					io.put_string (" int")
					io.new_line
				end
				i := i + 1
			end

			-- Print if variable is binary
			from
				i := 1
			until
				i > ncol
			loop
				if is_binary.item (i) = 1 then
					io.put_string ("x")
					io.put_integer (i)
					io.put_string (" binary")
					io.new_line
				end
				i := i + 1
			end
		end

	print_obj
		-- Print objective function.
		local
			j: INTEGER
		do
			if is_maxim = 1 then
				io.put_string ("max: ")
			else
				io.put_string ("min: ")
			end

			from
				j := 1
			until
				j > ncol
			loop
				io.put_double (rows.item (1, j))
				io.put_string (" * x")
				io.put_integer (j)
				if j < ncol then
					io.put_string (" + ")
				end
				j := j + 1
			end
			io.new_line
		end

	print_sol
		-- Print solutions.
		local
			j: INTEGER
		do
			if sol.status = 0 then
				io.put_string ("Solution%N")
				io.put_string ("Objective: ")
				io.put_double (sol.obj)
				io.new_line
				from
					j := 1
				until
					j > ncol
				loop
					io.put_string ("x")
					io.put_integer (j)
					io.put_string (" = ")
					io.put_double (sol.var.item (j))
					io.new_line
					j := j + 1
				end
			else
				io.put_string ("Not optimal solution found%N")
			end
		end

feature -- Access

	-- Number of rows
	nrow: INTEGER

	-- Number of columns
	ncol: INTEGER

	-- Rows
	rows: ARRAY2[REAL_64]

	-- Right hand side
	rh: ARRAY[REAL_64]

	-- Constraint type
	const_type: ARRAY[INTEGER]

	-- Is objective maximization?
	is_maxim: INTEGER

	-- Lower bounds of variables
	lowbo: ARRAY[REAL_64]

	-- Upper bounds of variables
	upbo: ARRAY[REAL_64]

	-- Is variable integer?
	is_int: ARRAY[INTEGER]

	-- Is variable binary?
	is_binary: ARRAY[INTEGER]

	-- Solution
	sol: SOLUTION
end
