note
	description: "A wrapper of lp_solve for EIFFEL."
	author: "Xiang Gao"
	date: "$Date$"
	revision: "$Revision$"

class
	LPLIB

create
	make

feature {NONE} -- Initialization
	make
		do
			create cache_list.make
		end

feature -- Cache

	-- Cache list contains all the cached models
	cache_list: LINKED_LIST[MODEL]

	-- Cache at most 10 models
	cache_size: INTEGER = 10

	search_cache (model: MODEL): MODEL
		-- Return the model if found, otherwise return void.
		do
			Result := Void
			from
				cache_list.start
			until
				Result /= Void or cache_list.after
			loop
				if model.is_equal (cache_list.item) then
					Result := cache_list.item
				end
				cache_list.forth
			end
		end

	insert_to_cache (model: MODEL)
		-- Replace the cache item under first in first out policy.
		do
			if cache_list.count >= 10 then
				cache_list.start
				cache_list.remove
			end
			cache_list.extend (model)
		end

	clear_cache
		-- Remove all the items in the cache.
		do
			cache_list.wipe_out
		end

feature -- Create/destroy model

	lp_make_lp (rows: INTEGER; columns: INTEGER): POINTER
		-- Create and initialise a new lprec structure.
		external
			"C (int, int): lprec* | %"lp_lib.h%""
 		alias
			"make_lp"
		end

	lp_read_LP (filename: POINTER; verbose: INTEGER; lp_name: POINTER): POINTER
		-- Create an lprec structure and read an lp model from file.
		-- The verbose level. Can be one of the following values:
		-- CRITICAL (1), SEVERE (2), IMPORTANT (3), NORMAL (4), DETAILED (5), FULL (6)
		require
			filename_not_null: filename /= default_pointer
			lp_name_not_null: lp_name /= default_pointer
		external
			"C (char *, int, char *): lprec* | %"lp_lib.h%""
 		alias
			"read_LP"
		end

	lp_read_MPS (filename: POINTER; options: INTEGER): POINTER
		-- Create an lprec structure and read an mps model from file.
		require
			filename_not_null: filename /= default_pointer
		external
			"C (char *, int): lprec* | %"lp_lib.h%""
 		alias
			"read_MPS"
		end

	lp_delete_lp (lp: POINTER)
		-- Deletes an lprec structure.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *) | %"lp_lib.h%""
 		alias
			"delete_lp"
		end

	lp_copy_lp (lp: POINTER): POINTER
		-- Copy an existing lprec structure to a new lprec structure.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): lprec* | %"lp_lib.h%""
 		alias
			"copy_lp"
		end

feature -- Write model to file

	lp_write_lp (lp: POINTER; filename: POINTER): INTEGER_8
		-- Write an lp model to a file.
		require
			lp_not_null: lp /= default_pointer
			filename_not_null: filename /= default_pointer
		external
			"C (lprec *, char *): unsigned char | %"lp_lib.h%""
 		alias
			"write_lp"
		end

feature -- Print settings

	lp_set_outputfile (lp: POINTER; filename: POINTER): INTEGER_8
		-- Defines the output when lp_solve has something to report.
		require
			lp_not_null: lp /= default_pointer
			filename_not_null: filename /= default_pointer
		external
			"C (lprec *, char *): unsigned char | %"lp_lib.h%""
 		alias
			"set_outputfile"
		end

feature -- Print

	lp_print_lp (lp: POINTER)
		-- Prints the lp model.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *) | %"lp_lib.h%""
 		alias
			"print_lp"
		end

	lp_print_solution (lp: POINTER; columns: INTEGER)
		-- Prints the solution (variables) of the lp.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int) | %"lp_lib.h%""
 		alias
			"print_solution"
		end

	lp_print_objective (lp: POINTER)
		-- Prints the objective value of the lp.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *) | %"lp_lib.h%""
 		alias
			"print_objective"
		end

	lp_print_constraints (lp: POINTER; columns: INTEGER)
		-- Prints the values of the constraints of the lp.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int) | %"lp_lib.h%""
 		alias
			"print_constraints"
		end

feature -- Build model

	lp_set_obj_fn (lp: POINTER; rp: POINTER): INTEGER_8
		-- Set the objective function (row 0) of the matrix.
		require
			lp_not_null: lp /= default_pointer
			rp_not_null: rp /= default_pointer
		external
			"C (lprec *, REAL *): unsigned char | %"lp_lib.h%""
 		alias
			"set_obj_fn"
		end

	lp_set_column (lp: POINTER; col: INTEGER; rp: POINTER): INTEGER_8
		-- Set a column in the lp.
		require
			lp_not_null: lp /= default_pointer
			rp_not_null: rp /= default_pointer
		external
			"C (lprec *, int, REAL *): unsigned char | %"lp_lib.h%""
 		alias
			"set_column"
		end

	lp_add_column (lp: POINTER; rp: POINTER): INTEGER_8
		-- Add a column to the lp.
		require
			lp_not_null: lp /= default_pointer
			rp_not_null: rp /= default_pointer
		external
			"C (lprec *, REAL *): unsigned char | %"lp_lib.h%""
 		alias
			"add_column"
		end

	lp_del_column (lp: POINTER; colnum: INTEGER): INTEGER_8
		-- Remove a column from the lp.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): unsigned char | %"lp_lib.h%""
 		alias
			"del_column"
		end

	lp_add_constraint (lp: POINTER; row: POINTER; constr_type: INTEGER; rh: REAL_64): INTEGER_8
		-- Add a constraint to the lp.
		-- Constraint type: LE(1), EQ(3), GE(2).
		-- rh is right hand side value.
		require
			lp_not_null: lp /= default_pointer
			row_not_null: row /= default_pointer
		external
			"C (lprec *, REAL *, int, REAL): unsigned char | %"lp_lib.h%""
 		alias
			"add_constraint"
		end

	lp_del_constraint (lp: POINTER; del_row: INTEGER): INTEGER_8
		-- Remove a constraint from the lp.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): unsigned char | %"lp_lib.h%""
 		alias
			"del_constraint"
		end

	lp_set_row (lp: POINTER; row_no: INTEGER; row: POINTER): INTEGER_8
		-- Set a constraint in the lp.
		require
			lp_not_null: lp /= default_pointer
			row_not_null: row /= default_pointer
		external
			"C (lprec *, int, REAL *): unsigned char | %"lp_lib.h%""
 		alias
			"set_row"
		end

	lp_set_binary (lp: POINTER; column: INTEGER; must_be_bin: INTEGER): INTEGER_8
		-- Set the type of the variable. Binary or floating point.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int, unsigned char): unsigned char | %"lp_lib.h%""
 		alias
			"set_binary"
		end

	lp_is_binary (lp: POINTER; column: INTEGER): INTEGER_8
		-- Gets the type of the variable. Binary integer or floating point.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): unsigned char | %"lp_lib.h%""
 		alias
			"is_binary"
		end

	lp_set_bounds (lp: POINTER; column: INTEGER; lower: REAL_64; upper: REAL_64): INTEGER_8
		-- Set the lower and upper bound of a variable.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int, REAL, REAL): unsigned char | %"lp_lib.h%""
 		alias
			"set_bounds"
		end

	lp_set_unbounded (lp: POINTER; column: INTEGER): INTEGER_8
		-- Sets if the variable is free.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): unsigned char | %"lp_lib.h%""
 		alias
			"set_unbounded"
		end

	lp_is_unbounded (lp: POINTER; column: INTEGER): INTEGER
		-- Returns if the variable is free.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): unsigned char | %"lp_lib.h%""
 		alias
			"is_unbounded"
		end

	lp_set_int (lp: POINTER; column: INTEGER; must_be_int: INTEGER): INTEGER_8
		-- Set the type of the variable. Integer or floating point.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int, unsigned char): unsigned char | %"lp_lib.h%""
 		alias
			"set_int"
		end

	lp_is_int (lp: POINTER; column: INTEGER): INTEGER
		-- Gets the type of the variable. Integer or floating point.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): unsigned char | %"lp_lib.h%""
 		alias
			"is_int"
		end

	lp_get_column (lp: POINTER; col_nr: INTEGER; column: POINTER): INTEGER_8
		-- Get all (get_column) or only the non-zero (get_columnex) column elements from the matrix.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int, REAL *): unsigned char | %"lp_lib.h%""
 		alias
			"get_column"
		end

	lp_get_row (lp: POINTER; row_nr: INTEGER; row: POINTER): INTEGER_8
		-- Get all (get_row) or only the non-zero (get_rowex) row elements from the matrix.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int, REAL *): unsigned char | %"lp_lib.h%""
 		alias
			"get_row"
		end

	lp_get_constr_type (lp: POINTER; row: INTEGER): INTEGER
		-- Gets the type of a constraint.
		-- LE (1) Less than or equal (<=)
		-- EQ (3) Equal (=)
		-- GE (2) Greater than or equal (>=)
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): int | %"lp_lib.h%""
 		alias
			"get_constr_type"
		end

	lp_get_lowbo (lp: POINTER; column: INTEGER): REAL_64
		-- Gets the lower bound of a variable.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): REAL | %"lp_lib.h%""
 		alias
			"get_lowbo"
		end

	lp_get_upbo (lp: POINTER; column: INTEGER): REAL_64
		-- Gets the upper bound of a variable.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): REAL | %"lp_lib.h%""
 		alias
			"get_upbo"
		end

	lp_set_lowbo (lp: POINTER; column: INTEGER; value: REAL_64): REAL_64
		-- Set the lower bound of a variable.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int, REAL): unsigned char | %"lp_lib.h%""
 		alias
			"set_lowbo"
		end

	lp_set_upbo (lp: POINTER; column: INTEGER; value: REAL_64): REAL_64
		-- Set the upper bound of a variable.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int, REAL): unsigned char | %"lp_lib.h%""
 		alias
			"set_upbo"
		end

	lp_set_rh (lp: POINTER; row: INTEGER; value: REAL_64): INTEGER_8
		-- Set the value of the right hand side (RHS) vector (column 0) for one row.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int, REAL): unsigned char | %"lp_lib.h%""
 		alias
			"set_rh"
		end

	lp_get_rh (lp: POINTER; row: INTEGER): REAL_64
		-- Gets the value of the right hand side (RHS) vector (column 0) for one row.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): REAL | %"lp_lib.h%""
 		alias
			"get_rh"
		end

	lp_set_var_branch (lp: POINTER; column: INTEGER; branch_mode: INTEGER): INTEGER_8
		-- Specifies, for the specified variable, which branch to take first in branch-and-bound algorithm.
		-- Branch mode:
		-- BRANCH_CEILING (0) Take ceiling branch first
		-- BRANCH_FLOOR (1) Take floor branch first
		-- BRANCH_AUTOMATIC (2) Algorithm decides which branch being taken first
		-- BRANCH_DEFAULT (3) Use the branch mode specified with set_bb_floorfirst
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int, int): unsigned char | %"lp_lib.h%""
 		alias
			"set_var_branch"
		end

	lp_get_var_branch (lp: POINTER; column: INTEGER): INTEGER
		-- Returns, for the specified variable, which branch to take first in branch-and-bound algorithm.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): int | %"lp_lib.h%""
 		alias
			"get_var_branch"
		end

	lp_set_row_name (lp: POINTER; row: INTEGER; new_name: POINTER): INTEGER_8
		-- Set the name of a constraint (row) in the lp.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int, char *): unsigned char | %"lp_lib.h%""
 		alias
			"set_row_name"
		end

	lp_get_row_name (lp: POINTER; row: INTEGER): POINTER
		-- Gets the name of a constraint (row) in the lp.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): char * | %"lp_lib.h%""
 		alias
			"get_row_name"
		end

	lp_set_col_name (lp: POINTER; column: INTEGER; new_name: POINTER): INTEGER_8
		-- Set the name of a column in the lp.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int, char *): unsigned char | %"lp_lib.h%""
 		alias
			"set_col_name"
		end

	lp_get_col_name (lp: POINTER; column: INTEGER): POINTER
		-- Gets the name of a column in the lp.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): char * | %"lp_lib.h%""
 		alias
			"get_col_name"
		end

	lp_resize_lp (lp: POINTER; rows: INTEGER; columns: INTEGER): INTEGER_8
		-- Allocate memory for the specified size.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int, int): unsigned char | %"lp_lib.h%""
 		alias
			"resize_lp"
		end

	lp_get_nameindex (lp: POINTER; name: POINTER; isrow: INTEGER): INTEGER
		-- Gets the index of a given column or row name in the lp.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, char *, unsigned char): int | %"lp_lib.h%""
 		alias
			"get_nameindex"
		end

feature -- Solver settings

	lp_set_timeout (lp: POINTER; sectimeout: INTEGER)
		-- Set a timeout.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, long) | %"lp_lib.h%""
 		alias
			"set_timeout"
		end

	lp_set_maxim (lp: POINTER)
		-- Set objective function to maximize.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *) | %"lp_lib.h%""
 		alias
			"set_maxim"
		end

	lp_set_minim (lp: POINTER)
		-- Set objective function to minimize.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *) | %"lp_lib.h%""
 		alias
			"set_minim"
		end

	lp_is_maxim (lp: POINTER): INTEGER
		-- Returns objective function direction.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): unsigned char | %"lp_lib.h%""
 		alias
			"is_maxim"
		end

feature -- Solve

	lp_solve (lp: POINTER): INTEGER
		-- solve the model.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec*): int | %"lp_lib.h%""
 		alias
			"solve"
		end

feature -- Solution

	lp_get_objective (lp: POINTER): REAL_64
		-- Returns the value of the objective function.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): REAL | %"lp_lib.h%""
 		alias
			"get_objective"
		end

	lp_get_ptr_variables (lp: POINTER; rp: POINTER): INTEGER_8
		-- Returns the values of the variables.
		-- rp is the pointer pointing to the variable value array.
		require
			lp_not_null: lp /= default_pointer
			rp_not_null: rp /= default_pointer
		external
			"C (lprec *, REAL **): unsigned char | %"lp_lib.h%""
 		alias
			"get_ptr_variables"
		end

	lp_get_variable (p: POINTER; ind: INTEGER): REAL_64
		-- Returns the value of the n-th variable.
		require
			p_not_null: p /= default_pointer
		external
			"C inline use %"lp_lib.h%""
		alias
			"[
			REAL Result;
			REAL *arr = (REAL *) $p;
			Result = (REAL) arr[$ind];
			return Result;
			]"
		end

	lp_get_ptr_constraints (lp: POINTER; rp: POINTER): INTEGER_8
		-- Returns the values of the constraints.
		-- rp is the pointer pointing to the constraint value array.
		require
			lp_not_null: lp /= default_pointer
			rp_not_null: rp /= default_pointer
		external
			"C (lprec *, REAL *): unsigned char | %"lp_lib.h%""
 		alias
			"get_ptr_constraints"
		end

	lp_get_constraint (p: POINTER; ind: INTEGER): REAL_64
		-- Returns the value of the n-th constraint.
		require
			p_not_null: p /= default_pointer
		external
			"C inline use %"lp_lib.h%""
		alias
			"[
			REAL Result;
			REAL *arr = (REAL *) $p;
			Result = (REAL) arr[$ind];
			return Result;
			]"
		end

feature -- Miscellaneous

	lp_time_elapsed (lp: POINTER): REAL_64
		-- Gets the time elapsed since start of solve.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): REAL | %"lp_lib.h%""
 		alias
			"time_elapsed"
		end

	lp_get_Ncolumns (lp: POINTER): INTEGER
		-- Returns the number of columns (variables) in the lp.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): int | %"lp_lib.h%""
 		alias
			"get_Ncolumns"
		end

	lp_get_Nrows (lp: POINTER): INTEGER
		-- Returns the number of rows (constraints) in the lp.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): int | %"lp_lib.h%""
 		alias
			"get_Nrows"
		end

	lp_get_status (lp: POINTER): INTEGER
		-- Returns an extra status after a call to a function.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): int | %"lp_lib.h%""
 		alias
			"get_status"
		end

feature -- Wrapper

	c_system (p: POINTER): INTEGER
		-- Wrapper of system function for command line tool.
		external
			"C (const char*): int | <stdlib.h>"
 		alias
			"system"
		end

end
