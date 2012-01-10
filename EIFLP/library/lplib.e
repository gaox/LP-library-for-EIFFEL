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

	lp_read_XLI (xliname: POINTER; modelname: POINTER; dataname: POINTER; options: POINTER; verbose: INTEGER): POINTER
		-- Create an lprec structure and read a model via the External Language Interface.
		require
			xliname_not_null: xliname /= default_pointer
			modelname_not_null: modelname /= default_pointer
			dataname_not_null: dataname /= default_pointer
		external
			"C (char *, char *, char *, char *, int): lprec* | %"lp_lib.h%""
 		alias
			"read_XLI"
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

	lp_write_mps (lp: POINTER; filename: POINTER): INTEGER_8
		-- Write an mps model.
		require
			lp_not_null: lp /= default_pointer
			filename_not_null: filename /= default_pointer
		external
			"C (lprec *, char *): unsigned char | %"lp_lib.h%""
 		alias
			"write_mps"
		end

	lp_write_XLI (lp: POINTER; filename: POINTER; options: POINTER; results: INTEGER_8): INTEGER_8
		-- Write a model to a file via the External Language Interface.
		require
			lp_not_null: lp /= default_pointer
			filename_not_null: filename /= default_pointer
		external
			"C (lprec *, char *, char *, unsigned char): unsigned char | %"lp_lib.h%""
 		alias
			"write_XLI"
		end

	lp_set_XLI (lp: POINTER; filename: POINTER): INTEGER_8
		-- Set External Language Interfaces package.
		require
			lp_not_null: lp /= default_pointer
			filename_not_null: filename /= default_pointer
		external
			"C (lprec *, char *): unsigned char | %"lp_lib.h%""
 		alias
			"set_XLI"
		end

	lp_has_XLI (lp: POINTER): INTEGER_8
		-- Returns if there is an external language interface (XLI) set.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): unsigned char | %"lp_lib.h%""
 		alias
			"has_XLI"
		end

	lp_is_nativeXLI (lp: POINTER): INTEGER_8
		-- Returns if a build-in External Language Interfaces (XLI) is available or not.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): unsigned char | %"lp_lib.h%""
 		alias
			"is_nativeXLI"
		end

feature -- Debug/Print settings

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

	lp_set_debug (lp: POINTER; deb: INTEGER_8)
		-- Sets a flag if all intermediate results and the branch-and-bound decisions must be printed while solving.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, unsigned char) | %"lp_lib.h%""
 		alias
			"set_debug"
		end

	lp_is_debug (lp: POINTER): INTEGER_8
		-- Returns a flag if all intermediate results and the branch-and-bound decisions must be printed while solving.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): unsigned char | %"lp_lib.h%""
 		alias
			"is_debug"
		end

	lp_set_lag_trace (lp: POINTER; lag_trace: INTEGER_8)
		-- Sets a flag if Lagrangian progression must be printed while solving.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, unsigned char) | %"lp_lib.h%""
 		alias
			"set_lag_trace"
		end

	lp_is_lag_trace (lp: POINTER): INTEGER_8
		-- Returns a flag if Lagrangian progression must be printed while solving.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): unsigned char | %"lp_lib.h%""
 		alias
			"is_lag_trace"
		end

	lp_set_print_sol (lp: POINTER; print_sol: INTEGER)
		-- Sets a flag if all intermediate valid solutions must be printed while solving.
		-- FALSE (0) No printing
		-- TRUE (1) Print all values
		-- AUTOMATIC (2) Print only non-zero values
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int) | %"lp_lib.h%""
 		alias
			"set_print_sol"
		end

	lp_get_print_sol (lp: POINTER): INTEGER
		-- Returns a flag if all intermediate valid solutions must be printed while solving.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): int | %"lp_lib.h%""
 		alias
			"get_print_sol"
		end

	lp_set_trace (lp: POINTER; trace: INTEGER_8)
		-- Sets a flag if pivot selection must be printed while solving.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, unsigned char) | %"lp_lib.h%""
 		alias
			"set_trace"
		end

	lp_is_trace (lp: POINTER): INTEGER_8
		-- Returns a flag if pivot selection must be printed while solving.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): unsigned char | %"lp_lib.h%""
 		alias
			"is_trace"
		end

	lp_set_verbose (lp: POINTER; verbose: INTEGER)
		-- Set the verbose level.
		-- NEUTRAL (0) Only some specific debug messages in de debug print routines are reported.
		-- CRITICAL (1) Only critical messages are reported. Hard errors like instability, out of memory, ...
		-- SEVERE (2) Only severe messages are reported. Errors.
		-- IMPORTANT (3) Only important messages are reported. Warnings and Errors.
		-- NORMAL (4) Normal messages are reported. This is the default.
		-- DETAILED (5) Detailed messages are reported. Like model size, continuing B&B improvements, ...
		-- FULL (6) All messages are reported. Useful for debugging purposes and small models.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int) | %"lp_lib.h%""
 		alias
			"set_verbose"
		end

	lp_get_verbose (lp: POINTER): INTEGER
		-- Returns the verbose level.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): int | %"lp_lib.h%""
 		alias
			"get_verbose"
		end

feature -- Debug/Print

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

	lp_print_debugdump (lp: POINTER; filename: POINTER): INTEGER_8
		-- Do a generic readable data dump of key lp_solve model variables; principally for run difference and debugging purposes.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, char *): unsigned char | %"lp_lib.h%""
 		alias
			"print_debugdump"
		end

	lp_print_duals (lp: POINTER)
		-- Prints the values of the duals of the lp.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *) | %"lp_lib.h%""
 		alias
			"print_duals"
		end

	lp_print_scales (lp: POINTER)
		-- Prints the scales of the lp.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *) | %"lp_lib.h%""
 		alias
			"print_scales"
		end

	lp_print_tableau (lp: POINTER)
		-- Prints the tableau.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *) | %"lp_lib.h%""
 		alias
			"print_tableau"
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

	lp_add_lag_con (lp: POINTER; row: POINTER; con_type: INTEGER; rhs: REAL_64): INTEGER_8
		-- Add a Lagrangian constraint to the lp.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, REAL *, int, REAL): unsigned char | %"lp_lib.h%""
 		alias
			"add_lag_con"
		end

	lp_add_SOS (lp: POINTER; name: POINTER; sostype: INTEGER; priority: INTEGER; count: INTEGER; sosvars: POINTER; weights: POINTER): INTEGER
		-- Add a SOS (Special Ordered Sets) constraint.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, char *, int, int, int, int *, REAL *): int | %"lp_lib.h%""
 		alias
			"add_SOS"
		end

	lp_is_SOS_var (lp: POINTER; column: INTEGER): INTEGER_8
		-- Returns if the variable is SOS (Special Ordered Set) or not.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): unsigned char | %"lp_lib.h%""
 		alias
			"is_SOS_var"
		end

	lp_is_infinite (lp: POINTER; value: REAL_64): INTEGER_8
		-- Checks if the provided absolute of the value is larger or equal to "infinite".
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, REAL): unsigned char | %"lp_lib.h%""
 		alias
			"is_infinite"
		end

	lp_is_negative (lp: POINTER; column: INTEGER): INTEGER_8
		-- Returns if the variable is negative.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): unsigned char | %"lp_lib.h%""
 		alias
			"is_negative"
		end

	lp_set_infinite (lp: POINTER; infinite: REAL_64)
		-- Specifies the practical value for "infinite".
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, REAL) | %"lp_lib.h%""
 		alias
			"set_infinite"
		end

	lp_get_infinite (lp: POINTER): REAL_64
		-- Returns the value of "infinite".
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): REAL | %"lp_lib.h%""
 		alias
			"get_infinite"
		end

	lp_set_lp_name (lp: POINTER; lpname: POINTER): INTEGER_8
		-- Set the name of the lp.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, char *): unsigned char | %"lp_lib.h%""
 		alias
			"set_lp_name"
		end

	lp_get_lp_name (lp: POINTER): POINTER
		-- Gets the name of the lp.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): char * | %"lp_lib.h%""
 		alias
			"get_lp_name"
		end

	lp_set_mat (lp: POINTER; row: INTEGER; column: INTEGER; value: REAL_64): INTEGER_8
		-- Set a single element in the matrix.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int, int, REAL): unsigned char | %"lp_lib.h%""
 		alias
			"set_mat"
		end

	lp_get_mat (lp: POINTER; row: INTEGER; column: INTEGER): REAL_64
		-- Get a single element from the matrix.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int, int): REAL | %"lp_lib.h%""
 		alias
			"get_mat"
		end

	lp_set_rh_range (lp: POINTER; row: INTEGER; deltavalue: REAL_64): INTEGER_8
		-- Set the range on a constraint.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int, REAL): unsigned char | %"lp_lib.h%""
 		alias
			"set_rh_range"
		end

	lp_get_rh_range (lp: POINTER; row: INTEGER): REAL_64
		-- Gets the range on a constraint.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): REAL | %"lp_lib.h%""
 		alias
			"get_rh_range"
		end

	lp_set_rh_vec (lp: POINTER; rh: POINTER)
		-- Set the right hand side (RHS) vector (column 0).
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, REAL *) | %"lp_lib.h%""
 		alias
			"set_rh_vec"
		end

	lp_set_semicont (lp: POINTER; column: INTEGER; must_be_sc: INTEGER_8): INTEGER_8
		-- Set the type of the variable. semi-continuous or not.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int, unsigned char): unsigned char | %"lp_lib.h%""
 		alias
			"set_semicont"
		end

	lp_is_semicont (lp: POINTER; column: INTEGER): INTEGER_8
		-- Gets the type of the variable. semi-continuous or not.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): unsigned char | %"lp_lib.h%""
 		alias
			"is_semicont"
		end

	lp_set_var_weights (lp: POINTER; weights: POINTER): INTEGER_8
		-- Set the weights on variables.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, REAL *): unsigned char | %"lp_lib.h%""
 		alias
			"set_var_weights"
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

	lp_get_timeout (lp: POINTER): INTEGER
		-- Gets the timeout.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): long | %"lp_lib.h%""
 		alias
			"get_timeout"
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

	lp_default_basis (lp: POINTER)
		-- Sets the starting base to an all slack basis (the default simplex starting basis).
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *) | %"lp_lib.h%""
 		alias
			"default_basis"
		end

	lp_read_basis (lp: POINTER; filename: POINTER; info: POINTER): INTEGER_8
		-- Read basis from a file and set as default basis.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, char *, char *): unsigned char | %"lp_lib.h%""
 		alias
			"read_basis"
		end

	lp_reset_basis (lp: POINTER)
		-- Causes reinversion at next opportunity.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *) | %"lp_lib.h%""
 		alias
			"reset_basis"
		end

	lp_write_basis (lp: POINTER; filename: POINTER): INTEGER_8
		-- Writes current basis to a file.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, char *): unsigned char | %"lp_lib.h%""
 		alias
			"write_basis"
		end

	lp_guess_basis (lp: POINTER; guessvector: POINTER; basisvector: POINTER): INTEGER_8
		-- Create a starting base from the provided guess vector.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, REAL *, int *): unsigned char | %"lp_lib.h%""
 		alias
			"guess_basis"
		end

	lp_read_params (lp: POINTER; filename: POINTER; options: POINTER): INTEGER_8
		-- Read settings from a parameter file.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, char *, char *): unsigned char | %"lp_lib.h%""
 		alias
			"read_params"
		end

	lp_write_params (lp: POINTER; filename: POINTER; options: POINTER): INTEGER_8
		-- Write settings to a parameter file.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, char *, char *): unsigned char | %"lp_lib.h%""
 		alias
			"write_params"
		end

	lp_reset_params (lp: POINTER)
		-- Resets parameters back to their default values.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *) | %"lp_lib.h%""
 		alias
			"reset_params"
		end

	lp_set_anti_degen (lp: POINTER; anti_degen: INTEGER)
		-- Specifies if special handling must be done to reduce degeneracy/cycling while solving.
		-- ANTIDEGEN_NONE (0) No anti-degeneracy handling
		-- ANTIDEGEN_FIXEDVARS (1) Check if there are equality slacks in the basis and try to drive them out in order to reduce chance of degeneracy in Phase 1
		-- ANTIDEGEN_COLUMNCHECK (2)
		-- ANTIDEGEN_STALLING (4)
		-- ANTIDEGEN_NUMFAILURE (8)
		-- ANTIDEGEN_LOSTFEAS (16)
		-- ANTIDEGEN_INFEASIBLE (32)
		-- ANTIDEGEN_DYNAMIC (64)
		-- ANTIDEGEN_DURINGBB (128)
		-- ANTIDEGEN_RHSPERTURB (256) Perturbation of the working RHS at refactorization
		-- ANTIDEGEN_BOUNDFLIP (512) Limit bound flips that can sometimes contribute to degeneracy in some models
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int) | %"lp_lib.h%""
 		alias
			"set_anti_degen"
		end

	lp_is_anti_degen (lp: POINTER; testmask: INTEGER): INTEGER_8
		-- Returns if the degeneracy rule specified in testmask is active.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): unsigned char | %"lp_lib.h%""
 		alias
			"is_anti_degen"
		end

	lp_set_basis (lp: POINTER; bascolumn: POINTER; nonbasic: INTEGER_8): INTEGER_8
		-- Sets an initial basis of the lp.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int *, unsigned char): unsigned char | %"lp_lib.h%""
 		alias
			"set_basis"
		end

	lp_get_basis (lp: POINTER; bascolumn: POINTER; nonbasic: INTEGER_8): INTEGER_8
		-- Returns the basis of the lp.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int *, unsigned char): unsigned char | %"lp_lib.h%""
 		alias
			"get_basis"
		end

	lp_set_basiscrash (lp: POINTER; mode: INTEGER)
		-- Determines a starting base.
		-- CRASH_NONE (0) No basis crash
		-- CRASH_MOSTFEASIBLE (2) Most feasible basis
		-- CRASH_LEASTDEGENERATE (3) Construct a basis that is in some measure the "least degenerate"
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int) | %"lp_lib.h%""
 		alias
			"set_basiscrash"
		end

	lp_get_basiscrash (lp: POINTER): INTEGER
		-- Determines a starting base.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): INTEGER | %"lp_lib.h%""
 		alias
			"get_basiscrash"
		end

	lp_set_bb_depthlimit (lp: POINTER; bb_maxlevel: INTEGER)
		-- Sets the maximum branch-and-bound depth.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int) | %"lp_lib.h%""
 		alias
			"set_bb_depthlimit"
		end

	lp_get_bb_depthlimit (lp: POINTER): INTEGER
		-- Returns the maximum branch-and-bound depth.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): int | %"lp_lib.h%""
 		alias
			"get_bb_depthlimit"
		end

	lp_set_bb_floorfirst (lp: POINTER; bb_floorfirst: INTEGER)
		-- Specifies which branch to take first in branch-and-bound algorithm.
		-- BRANCH_CEILING (0) Take ceiling branch first
		-- BRANCH_FLOOR (1) Take floor branch first
		-- BRANCH_AUTOMATIC (2) Algorithm decides which branch being taken first
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int) | %"lp_lib.h%""
 		alias
			"set_bb_floorfirst"
		end

	lp_get_bb_floorfirst (lp: POINTER): INTEGER
		-- Returns which branch to take first in branch-and-bound algorithm.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): int | %"lp_lib.h%""
 		alias
			"get_bb_floorfirst"
		end

	lp_set_bb_rule (lp: POINTER; bb_rule: INTEGER)
		-- Specifies the branch-and-bound rule.
		-- The branch-and-bound rule. Can by any of the following values:
		-- NODE_FIRSTSELECT (0) Select lowest indexed non-integer column
		-- NODE_GAPSELECT (1) Selection based on distance from the current bounds
		-- NODE_RANGESELECT (2) Selection based on the largest current bound
		-- NODE_FRACTIONSELECT (3) Selection based on largest fractional value
		-- NODE_PSEUDOCOSTSELECT (4) Simple, unweighted pseudo-cost of a variable
		-- NODE_PSEUDONONINTSELECT (5) This is an extended pseudo-costing strategy based on minimizing the number of integer infeasibilities
		-- NODE_PSEUDORATIOSELECT (6) This is an extended pseudo-costing strategy based on maximizing the normal pseudo-cost divided by the number of infeasibilities. Effectively, it is similar to (the reciprocal of) a cost/benefit ratio
		-- NODE_USERSELECT (7)
		-- One of these values may be or-ed with one or more of the following values:
		-- NODE_WEIGHTREVERSEMODE (8) Select by criterion minimum (worst), rather than criterion maximum (best)
		-- NODE_BRANCHREVERSEMODE (16) In case when get_bb_floorfirst is BRANCH_AUTOMATIC, select the oposite direction (lower/upper branch) that BRANCH_AUTOMATIC had chosen.
		-- NODE_GREEDYMODE (32)
		-- NODE_PSEUDOCOSTMODE (64) Toggles between weighting based on pseudocost or objective function value
		-- NODE_DEPTHFIRSTMODE (128) Select the node that has already been selected before the most number of times
		-- NODE_RANDOMIZEMODE (256) Adds a randomization factor to the score for any node candicate
		-- NODE_GUBMODE (512) Enables GUB mode. Still in development and should not be used at this time.
		-- NODE_DYNAMICMODE (1024) When NODE_DEPTHFIRSTMODE is selected, switch off this mode when a first solution is found.
		-- NODE_RESTARTMODE (2048) Enables regular restarts of pseudocost value calculations
		-- NODE_BREADTHFIRSTMODE (4096) Select the node that has been selected before the fewest number of times or not at all
		-- NODE_AUTOORDER (8192) Create an "optimal" B&B variable ordering. Can speed up B&B algorithm.
		-- NODE_RCOSTFIXING (16384) Do bound tightening during B&B based of reduced cost information
		-- NODE_STRONGINIT (32768) Initialize pseudo-costs by strong branching
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int) | %"lp_lib.h%""
 		alias
			"set_bb_rule"
		end

	lp_get_bb_rule (lp: POINTER): INTEGER
		-- Returns the branch-and-bound rule.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): int | %"lp_lib.h%""
 		alias
			"get_bb_rule"
		end

	lp_set_BFP (lp: POINTER; filename: POINTER): INTEGER_8
		-- Set basis factorization package.
		-- The name of the BFP package. Currently following BFPs are implemented:
		-- "bfp_etaPFI" original lp_solve product form of the inverse.
		-- "bfp_LUSOL" LU decomposition.
		-- "bfp_GLPK" GLPK LU decomposition.
		-- NULL The default BFP package.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, char *): unsigned char | %"lp_lib.h%""
 		alias
			"set_BFP"
		end

	lp_has_BFP (lp: POINTER): INTEGER_8
		-- Returns if there is a basis factorization package (BFP) available.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): unsigned char | %"lp_lib.h%""
 		alias
			"has_BFP"
		end

	lp_is_nativeBFP (lp: POINTER): INTEGER_8
		-- Returns if the native (build-in) basis factorization package (BFP) is used, or an external package.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): unsigned char | %"lp_lib.h%""
 		alias
			"is_nativeBFP"
		end

	lp_set_break_at_first (lp: POINTER; break_at_first: INTEGER_8)
		-- Specifies if the branch-and-bound algorithm stops at first found solution.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, unsigned char) | %"lp_lib.h%""
 		alias
			"set_break_at_first"
		end

	lp_is_break_at_first (lp: POINTER): INTEGER_8
		-- Returns if the branch-and-bound algorithm stops at first found solution.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): unsigned char | %"lp_lib.h%""
 		alias
			"is_break_at_first"
		end

	lp_set_break_at_value (lp: POINTER; break_at_value: REAL_64)
		-- Specifies if the branch-and-bound algorithm stops when the object value is better than a given value.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, REAL) | %"lp_lib.h%""
 		alias
			"set_break_at_value"
		end

	lp_get_break_at_value (lp: POINTER): REAL_64
		-- Returns the value at which the branch-and-bound algorithm stops when the object value is better than this value.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): REAL | %"lp_lib.h%""
 		alias
			"get_break_at_value"
		end

	lp_set_epsb (lp: POINTER; epsb: REAL_64)
		-- Specifies the value that is used as a tolerance for the Right Hand Side (RHS) to determine whether a value should be considered as 0.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, REAL) | %"lp_lib.h%""
 		alias
			"set_epsb"
		end

	lp_get_epsb (lp: POINTER): REAL_64
		-- Returns the value that is used as a tolerance for the Right Hand Side (RHS) to determine whether a value should be considered as 0.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): REAL | %"lp_lib.h%""
 		alias
			"get_epsb"
		end

	lp_set_epsd (lp: POINTER; epsd: REAL_64)
		-- Specifies the value that is used as a tolerance for reduced costs to determine whether a value should be considered as 0.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, REAL) | %"lp_lib.h%""
 		alias
			"set_epsd"
		end

	lp_get_epsd (lp: POINTER): REAL_64
		-- Returns the value that is used as a tolerance for the reduced costs to determine whether a value should be considered as 0.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): REAL | %"lp_lib.h%""
 		alias
			"get_epsd"
		end

	lp_set_epsel (lp: POINTER; epsel: REAL_64)
		-- Specifies the value that is used as a tolerance for rounding values to zero.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, REAL) | %"lp_lib.h%""
 		alias
			"set_epsel"
		end

	lp_get_epsel (lp: POINTER): REAL_64
		-- Returns the value that is used as a tolerance for rounding values to zero.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): REAL | %"lp_lib.h%""
 		alias
			"get_epsel"
		end

	lp_set_epsint (lp: POINTER; epsint: REAL_64)
		-- Specifies the tolerance that is used to determine whether a floating-point number is in fact an integer.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, REAL) | %"lp_lib.h%""
 		alias
			"set_epsint"
		end

	lp_get_epsint (lp: POINTER): REAL_64
		-- Returns the tolerance that is used to determine whether a floating-point number is in fact an integer.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): REAL | %"lp_lib.h%""
 		alias
			"get_epsint"
		end

	lp_set_epsperturb (lp: POINTER; epsperturb: REAL_64)
		-- Specifies the value that is used as perturbation scalar for degenerative problems.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, REAL) | %"lp_lib.h%""
 		alias
			"set_epsperturb"
		end

	lp_get_epsperturb (lp: POINTER): REAL_64
		-- Returns the value that is used as perturbation scalar for degenerative problems.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): REAL | %"lp_lib.h%""
 		alias
			"get_epsperturb"
		end

	lp_set_epspivot (lp: POINTER; epspivot: REAL_64)
		-- Specifies the value that is used as a tolerance pivot element to determine whether a value should be considered as 0.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, REAL) | %"lp_lib.h%""
 		alias
			"set_epspivot"
		end

	lp_get_epspivot (lp: POINTER): REAL_64
		-- Returns epspivot.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): REAL | %"lp_lib.h%""
 		alias
			"get_epspivot"
		end

	lp_set_epslevel (lp: POINTER; epslevel: INTEGER)
		-- This is a simplified way of specifying multiple eps thresholds that are "logically" consistent.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int) | %"lp_lib.h%""
 		alias
			"set_epslevel"
		end

	lp_set_improve (lp: POINTER; improve: INTEGER)
		-- Specifies the iterative improvement level.
		-- IMPROVE_NONE (0) improve none
		-- IMPROVE_SOLUTION (1) Running accuracy measurement of solved equations based on Bx=r (primal simplex), remedy is refactorization.
		-- IMPROVE_DUALFEAS (2) Improve initial dual feasibility by bound flips (highly recommended, and default)
		-- IMPROVE_THETAGAP (4) Low-cost accuracy monitoring in the dual, remedy is refactorization
		-- IMPROVE_BBSIMPLEX (8) By default there is a check for primal/dual feasibility at optimum only for the relaxed problem, this also activates the test at the node level
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int) | %"lp_lib.h%""
 		alias
			"set_improve"
		end

	lp_get_improve (lp: POINTER): INTEGER
		-- Returns the iterative improvement level.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): int | %"lp_lib.h%""
 		alias
			"get_improve"
		end

	lp_set_maxpivot (lp: POINTER; max_num_inv: INTEGER)
		-- Sets the maximum number of pivots between a re-inversion of the matrix.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int) | %"lp_lib.h%""
 		alias
			"set_maxpivot"
		end

	lp_get_maxpivot (lp: POINTER): INTEGER
		-- Returns the maximum number of pivots between a re-inversion of the matrix.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): int | %"lp_lib.h%""
 		alias
			"get_maxpivot"
		end

	lp_set_mip_gap (lp: POINTER; absolute: INTEGER_8; mip_gap: REAL_64)
		-- Specifies the MIP gap value.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, unsigned char, REAL) | %"lp_lib.h%""
 		alias
			"set_mip_gap"
		end

	lp_get_mip_gap (lp: POINTER; absolute: INTEGER_8): REAL_64
		-- Returns the MIP gap value.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, unsigned char): REAL | %"lp_lib.h%""
 		alias
			"get_mip_gap"
		end

	lp_set_negrange (lp: POINTER; negrange: REAL_64)
		-- Set negative value below which variables are split into a negative and a positive part.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, REAL) | %"lp_lib.h%""
 		alias
			"set_negrange"
		end

	lp_get_negrange (lp: POINTER): REAL_64
		-- Returns the negative value below which variables are split into a negative and a positive part.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): REAL | %"lp_lib.h%""
 		alias
			"get_negrange"
		end

	lp_set_obj_in_basis (lp: POINTER; obj_in_basis: INTEGER_8)
		-- Specifies if the objective is in the matrix or not.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, unsigned char) | %"lp_lib.h%""
 		alias
			"set_obj_in_basis"
		end

	lp_is_obj_in_basis (lp: POINTER): INTEGER_8
		-- Returns if the objective is in the matrix or not.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): unsigned char | %"lp_lib.h%""
 		alias
			"is_obj_in_basis"
		end

	lp_set_pivoting (lp: POINTER; pivoting: INTEGER)
		-- Sets the pivot rule and mode.
		-- The pivot rule and mode. Can be one of the following rules:
		-- PRICER_FIRSTINDEX (0) Select first
		-- PRICER_DANTZIG (1) Select according to Dantzig
		-- PRICER_DEVEX (2) Devex pricing from Paula Harris
		-- PRICER_STEEPESTEDGE (3) Steepest Edge
		-- Some of these values can be combined with any (ORed) of the following modes:
		-- PRICE_PRIMALFALLBACK (4) In case of Steepest Edge, fall back to DEVEX in primal
		-- PRICE_MULTIPLE (8) Preliminary implementation of the multiple pricing scheme. This means that attractive candidate entering columns from one iteration may be used in the subsequent iteration, avoiding full updating of reduced costs.  In the current implementation, lp_solve only reuses the 2nd best entering column alternative
		-- PRICE_PARTIAL (16) Enable partial pricing
		-- PRICE_ADAPTIVE (32) Temporarily use alternative strategy if cycling is detected
		-- PRICE_RANDOMIZE (128) Adds a small randomization effect to the selected pricer
		-- PRICE_AUTOPARTIAL (512) Indicates automatic detection of segmented/staged/blocked models. It refers to partial pricing rather than full pricing. With full pricing, all non-basic columns are scanned, but with partial pricing only a subset is scanned for every iteration. This can speed up several models
		-- PRICE_LOOPLEFT (1024) Scan entering/leaving columns left rather than right
		-- PRICE_LOOPALTERNATE (2048) Scan entering/leaving columns alternatingly left/right
		-- PRICE_HARRISTWOPASS (4096) Use Harris' primal pivot logic rather than the default
		-- PRICE_TRUENORMINIT (16384) Use true norms for Devex and Steepest Edge initializations
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int) | %"lp_lib.h%""
 		alias
			"set_pivoting"
		end

	lp_get_pivoting (lp: POINTER): INTEGER
		-- Returns the pivot rule and mode.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): int | %"lp_lib.h%""
 		alias
			"get_pivoting"
		end

	lp_is_piv_mode (lp: POINTER; testmask: INTEGER): INTEGER_8
		-- Returns if pivot mode specified in testmask is active.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): unsigned char | %"lp_lib.h%""
 		alias
			"is_piv_mode"
		end

	lp_is_piv_rule (lp: POINTER; rule: INTEGER): INTEGER_8
		-- Checks if the specified pivot rule is active.
		-- Can be one of the following values: PRICER_FIRSTINDEX (0) Select first
		-- PRICER_DANTZIG (1) Select according to Dantzig
		-- PRICER_DEVEX (2) Devex pricing from Paula Harris
		-- PRICER_STEEPESTEDGE (3) Steepest Edge
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): unsigned char | %"lp_lib.h%""
 		alias
			"is_piv_rule"
		end

	lp_set_preferdual (lp: POINTER; dodual: INTEGER_8)
		-- Sets the desired combination of primal and dual simplex algorithms.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, unsigned char) | %"lp_lib.h%""
 		alias
			"set_preferdual"
		end

	lp_set_presolve (lp: POINTER; do_presolve: INTEGER; maxloops: INTEGER)
		-- Specifies if a presolve must be done before solving.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int, int) | %"lp_lib.h%""
 		alias
			"set_presolve"
		end

	lp_get_presolve (lp: POINTER): INTEGER
		-- Specifies if a presolve must be done before solving.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): int | %"lp_lib.h%""
 		alias
			"get_presolve"
		end

	lp_get_presolveloops (lp: POINTER): INTEGER
		-- Returns the number of times presolve is done.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): int | %"lp_lib.h%""
 		alias
			"get_presolveloops"
		end

	lp_is_presolve (lp: POINTER; testmask: INTEGER): INTEGER_8
		-- Returns if presolve level specified in testmask is active.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): unsigned char | %"lp_lib.h%""
 		alias
			"is_presolve"
		end

	lp_set_scalelimit (lp: POINTER; scalelimit: REAL_64)
		-- Sets the relative scaling convergence criterion for the active scaling mode; the integer part specifies the maximum number of iterations.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, REAL) | %"lp_lib.h%""
 		alias
			"set_scalelimit"
		end

	lp_get_scalelimit (lp: POINTER): REAL_64
		-- Sets the relative scaling convergence criterion for the active scaling mode.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): REAL | %"lp_lib.h%""
 		alias
			"get_scalelimit"
		end

	lp_set_scaling (lp: POINTER; scalemode: INTEGER)
		-- Specifies which scaling algorithm must be used.
		-- Specifies which scaling algorithm must be used. Can by any of the following values:
		-- SCALE_NONE (0) No scaling
		-- SCALE_EXTREME (1) Scale to convergence using largest absolute value
		-- SCALE_RANGE (2) Scale based on the simple numerical range
		-- SCALE_MEAN (3) Numerical range-based scaling
		-- SCALE_GEOMETRIC (4) Geometric scaling
		-- SCALE_CURTISREID (7) Curtis-reid scaling
		-- Additionally, the value can be OR-ed with any combination of one of the following values:
		-- SCALE_QUADRATIC (8)
		-- SCALE_LOGARITHMIC (16) Scale to convergence using logarithmic mean of all values
		-- SCALE_USERWEIGHT (31) User can specify scalars
		-- SCALE_POWER2 (32) also do Power scaling
		-- SCALE_EQUILIBRATE (64) Make sure that no scaled number is above 1
		-- SCALE_INTEGERS (128) also scaling integer variables
		-- SCALE_DYNUPDATE (256) dynamic update
		-- SCALE_ROWSONLY (512) scale only rows
		-- SCALE_COLSONLY (1024) scale only columns
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int) | %"lp_lib.h%""
 		alias
			"set_scaling"
		end

	lp_get_scaling (lp: POINTER): INTEGER
		-- Specifies which scaling algorithm is used.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): int | %"lp_lib.h%""
 		alias
			"get_scaling"
		end

	lp_is_integerscaling (lp: POINTER): INTEGER_8
		-- Returns if integer scaling is active.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): unsigned char | %"lp_lib.h%""
 		alias
			"is_integerscaling"
		end

	lp_is_scalemode (lp: POINTER; testmask: INTEGER): INTEGER_8
		-- Returns if scaling mode specified in testmask is active.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): unsigned char | %"lp_lib.h%""
 		alias
			"is_scalemode"
		end

	lp_is_scaletype (lp: POINTER; scaletype: INTEGER): INTEGER_8
		-- Returns if scaling type specified in scaletype is active.
		-- scaletype
		-- SCALE_EXTREME (1) Scale to convergence using largest absolute value
		-- SCALE_RANGE (2) Scale based on the simple numerical range
		-- SCALE_MEAN (3) Numerical range-based scaling
		-- SCALE_GEOMETRIC (4) Geometric scaling
		-- SCALE_CURTISREID (7) Curtis-reid scaling
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): unsigned char | %"lp_lib.h%""
 		alias
			"is_scaletype"
		end

	lp_set_sense (lp: POINTER; maximize: INTEGER_8)
		-- Set objective function sense.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, unsigned char) | %"lp_lib.h%""
 		alias
			"set_sense"
		end

	lp_set_simplextype (lp: POINTER; simplextype: INTEGER)
		-- Sets the desired combination of primal and dual simplex algorithms.
		-- simplextype
		-- The desired combination of primal and dual simplex algorithms. Can by any of the following values:
		-- SIMPLEX_PRIMAL_PRIMAL (5) Phase1 Primal, Phase2 Primal
		-- SIMPLEX_DUAL_PRIMAL (6) Phase1 Dual, Phase2 Primal
		-- SIMPLEX_PRIMAL_DUAL (9) Phase1 Primal, Phase2 Dual
		-- SIMPLEX_DUAL_DUAL (10) Phase1 Dual, Phase2 Dual
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int) | %"lp_lib.h%""
 		alias
			"set_simplextype"
		end

	lp_get_simplextype (lp: POINTER): INTEGER
		-- Returns the desired combination of primal and dual simplex algorithms.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): int | %"lp_lib.h%""
 		alias
			"get_simplextype"
		end

	lp_set_solutionlimit (lp: POINTER; limit: INTEGER)
		-- Sets the solution number that must be returned.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int) | %"lp_lib.h%""
 		alias
			"set_solutionlimit"
		end

	lp_get_solutionlimit (lp: POINTER): INTEGER
		-- Returns the solution number that must be returned.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): int | %"lp_lib.h%""
 		alias
			"get_solutionlimit"
		end

	lp_set_use_names (lp: POINTER; isrow: INTEGER_8; use_names: INTEGER_8)
		-- Sets if variable or constraint names are used.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, unsigned char, unsigned char) | %"lp_lib.h%""
 		alias
			"set_use_names"
		end

	lp_is_use_names (lp: POINTER; isrow: INTEGER_8): INTEGER_8
		-- Returns if variable or constraint names are used.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, unsigned char): unsigned char | %"lp_lib.h%""
 		alias
			"is_use_names"
		end

	lp_unscale (lp: POINTER)
		-- Unscales the model.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *) | %"lp_lib.h%""
 		alias
			"unscale"
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

	lp_get_primal_solution (lp: POINTER; pv: POINTER): INTEGER_8
		-- Returns the value of the objective function.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, REAL *): unsigned char | %"lp_lib.h%""
 		alias
			"get_primal_solution"
		end

	lp_get_sensitivity_obj (lp: POINTER; objfrom: POINTER; objtill: POINTER): INTEGER_8
		-- Returns the sensitivity of the objective function.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, REAL *, REAL *): unsigned char | %"lp_lib.h%""
 		alias
			"get_sensitivity_obj"
		end

	lp_get_sensitivity_rhs (lp: POINTER; duals: POINTER; dualsfrom: POINTER; dualstill: POINTER): INTEGER_8
		-- Returns the sensitivity of the constraints and the variables.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, REAL *, REAL *, REAL *): unsigned char | %"lp_lib.h%""
 		alias
			"get_sensitivity_rhs"
		end

	lp_get_solutioncount (lp: POINTER): INTEGER
		-- Returns the number of equal solutions.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): int | %"lp_lib.h%""
 		alias
			"get_solutioncount"
		end

	lp_get_total_iter (lp: POINTER): INTEGER_64
		-- Returns the total number of iterations.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): long long | %"lp_lib.h%""
 		alias
			"get_total_iter"
		end

	lp_get_total_nodes (lp: POINTER): INTEGER_64
		-- Returns the total number of nodes processed in branch-and-bound.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): long long | %"lp_lib.h%""
 		alias
			"get_total_nodes"
		end

	lp_get_working_objective (lp: POINTER): REAL_64
		-- Returns the value of the objective function.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): REAL | %"lp_lib.h%""
 		alias
			"get_working_objective"
		end

	lp_is_feasible (lp: POINTER; values: POINTER; threshold: REAL_64): INTEGER_8
		-- Checks if provided solution is a feasible solution.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, REAL *, REAL): unsigned char | %"lp_lib.h%""
 		alias
			"is_feasible"
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

	lp_dualize_lp (lp: POINTER): INTEGER_8
		-- Create the dual of the current model.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): unsigned char | %"lp_lib.h%""
 		alias
			"dualize_lp"
		end

	lp_get_lp_index (lp: POINTER; orig_index: INTEGER): INTEGER_8
		-- Returns the index in the lp of the original row/column.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): unsigned char | %"lp_lib.h%""
 		alias
			"get_lp_index"
		end

	lp_get_nonzeros (lp: POINTER): INTEGER
		-- Returns the number of non-zero elements in the matrix.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): int | %"lp_lib.h%""
 		alias
			"get_nonzeros"
		end

	lp_get_Norig_columns (lp: POINTER): INTEGER
		-- Returns the number of original columns (variables) in the lp.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): int | %"lp_lib.h%""
 		alias
			"get_Norig_columns"
		end

	lp_get_Norig_rows (lp: POINTER): INTEGER
		-- Returns the number of original rows (constraints) in the lp.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *): int | %"lp_lib.h%""
 		alias
			"get_Norig_rows"
		end

	lp_get_orig_index (lp: POINTER; lp_index: INTEGER): INTEGER
		-- Returns the original row/column where a constraint/variable was before presolve.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): int | %"lp_lib.h%""
 		alias
			"get_orig_index"
		end

	lp_get_statustext (lp: POINTER; statuscode: INTEGER): POINTER
		-- Returns the description of a returncode of the solve function.
		require
			lp_not_null: lp /= default_pointer
		external
			"C (lprec *, int): char * | %"lp_lib.h%""
 		alias
			"get_statustext"
		end

	lp_lp_solve_version (majorversion: POINTER; minorversion: POINTER; release: POINTER; build: POINTER)
		-- Returns the description of a returncode of the solve function.
		external
			"C (int *, int *, int *, int *) | %"lp_lib.h%""
 		alias
			"lp_solve_version"
		end

feature -- Callback routines

	lp_put_abortfunc (lp: POINTER; newctrlc: POINTER; ctrlchandle: POINTER)
		-- Sets an abort routine.
		require
			lp_not_null: lp /= default_pointer
		external
			"C inline use %"lp_lib.h%""
 		alias
			"[
			typedef int (__WINAPI lphandle_intfunc)(lprec *, void *);
			lphandle_intfunc *callback = (lphandle_intfunc *) $newctrlc;
			lprec *lp1 = (lprec *) $lp;
			void *handle = (void *) $ctrlchandle;
			put_abortfunc(lp1, callback, handle);
			]"
		end

	lp_put_bb_branchfunc (lp: POINTER; newbranch: POINTER; bb_branchhandle: POINTER)
		-- Specifies a user function to select a B&B branching, given the column to branch on.
		require
			lp_not_null: lp /= default_pointer
		external
			"C inline use %"lp_lib.h%""
 		alias
			"[
			typedef int (__WINAPI lphandleint_intfunc)(lprec *, void *, int);
			lphandleint_intfunc  *callback = (lphandleint_intfunc *) $newbranch;
			lprec *lp1 = (lprec *) $lp;
			void *handle = (void *) $bb_branchhandle;
			put_bb_branchfunc(lp1, callback, handle);
			]"
		end

	lp_put_bb_nodefunc (lp: POINTER; newnode: POINTER; bbnodehandle: POINTER)
		-- Allows to set a user function that specifies which
		-- non-integer variable to select next to make integer in the B&B solve.
		require
			lp_not_null: lp /= default_pointer
		external
			"C inline use %"lp_lib.h%""
 		alias
			"[
			typedef int (__WINAPI lphandleint_intfunc)(lprec *, void *, int);
			lphandleint_intfunc  *callback = (lphandleint_intfunc *) $newnode;
			lprec *lp1 = (lprec *) $lp;
			void *handle = (void *) $bbnodehandle;
			put_bb_nodefunc(lp1, callback, handle);
			]"
		end

	lp_put_logfunc (lp: POINTER; newlog: POINTER; loghandle: POINTER)
		-- Sets a log routine.
		require
			lp_not_null: lp /= default_pointer
		external
			"C inline use %"lp_lib.h%""
 		alias
			"[
			typedef void (__WINAPI lphandlestr_func)(lprec *, void *, char *);
			lphandlestr_func  *callback = (lphandlestr_func *) $newlog;
			lprec *lp1 = (lprec *) $lp;
			void *handle = (void *) $loghandle;
			put_logfunc(lp1, callback, handle);
			]"
		end

	lp_put_msgfunc (lp: POINTER; newmsg: POINTER; msghandle: POINTER; mask: INTEGER)
		-- Sets a message routine.
		require
			lp_not_null: lp /= default_pointer
		external
			"C inline use %"lp_lib.h%""
 		alias
			"[
			typedef void (__WINAPI lphandleint_func)(lprec *, void *, int);
			lphandleint_func  *callback = (lphandleint_func *) $newmsg;
			lprec *lp1 = (lprec *) $lp;
			void *handle = (void *) $msghandle;
			int mask1 = (int) $mask;
			put_msgfunc(lp1, callback, handle, mask1);
			]"
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
