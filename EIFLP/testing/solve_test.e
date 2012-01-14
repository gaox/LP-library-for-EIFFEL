note
	description: "Test solving a model."
	author: "Xiang Gao"
	date: "$Date$"
	revision: "$Revision$"

class
	SOLVE_TEST

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
		do
			io.put_string ("-----Start running solve test%N")
			create lib.make
			create filename.make ("testcase\1.lp")
			create modelname.make ("1.model")
			lp := lib.lp_read_lp(filename.item, 4, modelname.item)
			create model.make (lp, lib)
			model.solve (lp, lib)
			model.print_obj
			model.print_const
			model.print_sol
			io.put_string ("*****Finish solve test%N")
			io.new_line
			lib.lp_delete_lp (lp)
		end
end
