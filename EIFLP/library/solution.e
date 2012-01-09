note
	description: "Solution of the model."
	author: "Xiang Gao"
	date: "$Date$"
	revision: "$Revision$"

class
	SOLUTION

create
	make

feature {NONE}  -- Initialization

	make (lp: POINTER; lib: LPLIB)

		local
			vararr: POINTER
			tie: INTEGER

			i: INTEGER
		do
			status := lib.lp_solve (lp)
			ncol := lib.lp_get_ncolumns (lp)
			create var.make_filled (0, 1, ncol)
			if status = 0 then
				tie := lib.lp_get_ptr_variables(lp, $vararr)
				from
					i := 1
				until
					i > ncol
				loop
					var.put(lib.lp_get_variable(vararr, i - 1), i)
					i := i + 1
				end
				obj := lib.lp_get_objective (lp)
			end
		end

feature -- Access

	-- Objective value
	obj: REAL_64

	-- Number of variables
	ncol: INTEGER

	-- Variable value
	var: ARRAY[REAL_64]

	-- Solution status
	-- NOMEMORY (-2) Out of memory
	-- OPTIMAL (0) An optimal solution was obtained
	-- SUBOPTIMAL (1) The model is sub-optimal. Only happens if there are integer variables
	-- and there is already an integer solution found. The solution is not guaranteed the most optimal one.
	-- A timeout occured (set via set_timeout or with the -timeout option in lp_solve)
	-- set_break_at_first was called so that the first found integer solution is found (-f option in lp_solve)
	-- set_break_at_value was called so that when integer solution is found that is better than the specified value that it stops (-o option in lp_solve)
	-- set_mip_gap was called (-g/-ga/-gr options in lp_solve) to specify a MIP gap
	-- An abort function is installed (put_abortfunc) and this function returned TRUE
	-- At some point not enough memory could not be allocated
	-- INFEASIBLE (2) The model is infeasible
	-- UNBOUNDED (3) The model is unbounded
	-- DEGENERATE (4) The model is degenerative
	-- NUMFAILURE (5) Numerical failure encountered
	-- USERABORT (6) The abort routine returned TRUE. See put_abortfunc
	-- TIMEOUT (7) A timeout occurred. A timeout was set via set_timeout
	-- PRESOLVED (9) The model could be solved by presolve. This can only happen if presolve is active via set_presolve
	-- PROCFAIL (10) The B&B routine failed
	-- PROCBREAK (11) The B&B was stopped because of a break-at-first (see set_break_at_first) or a break-at-value (see set_break_at_value)
	-- FEASFOUND (12) A feasible B&B solution was found
	-- NOFEASFOUND (13) No feasible B&B solution found
	status: INTEGER

end
