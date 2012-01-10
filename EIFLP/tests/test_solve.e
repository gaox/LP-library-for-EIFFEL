note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_SOLVE

inherit
	EQA_TEST_SET

feature -- Test routines

	test_solve_1
			-- New test routine
		note
			testing:  "solve"
		local
			-- LP library
			lib: LPLIB

			-- Build the model
			lp: POINTER
			filename: C_STRING
			modelname: C_STRING
			model: MODEL
		do
			io.put_string ("-----Start running solvetest%N")
			create lib.make
			create filename.make ("C:\Users\thinkpad\Documents\Eiffel 6.8 User Files\projects\EIFLP\EIFLP\testcase\1.lp")
			create modelname.make ("1.model")
			lp := lib.lp_read_lp(filename.item, 4, modelname.item)
			create model.make (lp, lib)
			model.solve (lp, lib)
			model.print_obj
			model.print_const
			model.print_sol
			io.put_string ("*****Finish solvetest%N")

			lib.lp_delete_lp (lp)
		end

	test_solve_2
			-- New test routine
		note
			testing:  "solve"
		local
			-- LP library
			lib: LPLIB

			-- Build the model
			lp: POINTER
			filename: C_STRING
			modelname: C_STRING
			model: MODEL
		do
			io.put_string ("-----Start running solvetest%N")
			create lib.make
			create filename.make ("C:\Users\thinkpad\Documents\Eiffel 6.8 User Files\projects\EIFLP\EIFLP\testcase\2.lp")
			create modelname.make ("2.model")
			lp := lib.lp_read_lp(filename.item, 4, modelname.item)
			create model.make (lp, lib)
			model.solve (lp, lib)
			model.print_obj
			model.print_const
			model.print_sol
			io.put_string ("*****Finish solvetest%N")

			lib.lp_delete_lp (lp)
		end

	test_solve_3
			-- New test routine
		note
			testing:  "solve"
		local
			-- LP library
			lib: LPLIB

			-- Build the model
			lp: POINTER
			filename: C_STRING
			model: MODEL
		do
			io.put_string ("-----Start running solvetest%N")
			create lib.make
			create filename.make ("C:\Users\thinkpad\Documents\Eiffel 6.8 User Files\projects\EIFLP\EIFLP\testcase\3.mps")
			lp := lib.lp_read_MPS(filename.item, 4)
			create model.make (lp, lib)
			model.solve (lp, lib)
			model.print_obj
			model.print_const
			model.print_sol
			io.put_string ("*****Finish solvetest%N")

			lib.lp_delete_lp (lp)
		end
end


