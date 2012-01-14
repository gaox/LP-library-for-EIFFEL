note
	description: "Test simplex algorithm."
	author: "Xiang Gao"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLEX_TEST

inherit
	TEST

create
	make

feature {NONE} -- Initialization

	make
		do

		end

feature -- Test

	run
		-- Run the solve test.
		local
			-- LP library
			lib: LPLIB

			-- Build the model
			lp: POINTER
			filename: C_STRING
			modelname: C_STRING
			model: MODEL

			-- Simplex
			simplex: SIMPLEX
		do
			io.put_string ("-----Start running simplex test%N")
			create lib.make
			create filename.make ("testcase\4.lp")
			create modelname.make ("4.model")
			lp := lib.lp_read_lp(filename.item, 4, modelname.item)
			create model.make (lp, lib)
			create simplex.make (model)
			simplex.print_tableaux
			simplex.solve
			simplex.print_optimal
			io.put_string ("#####Solution from the lp_solve library%N")
			model.print_sol
			io.put_string ("*****Finish simplex test%N")
			io.new_line
			lib.lp_delete_lp (lp)
		end
end
