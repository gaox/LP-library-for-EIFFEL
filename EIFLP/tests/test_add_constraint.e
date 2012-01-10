note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_ADD_CONSTRAINT

inherit
	EQA_TEST_SET

feature -- Test routines

	test_add_constraint_1
			-- New test routine
		note
			testing:  "constraint"
		local
			-- LP library
			lib: LPLIB

			-- Build the model
			lp: POINTER
			row: MANAGED_POINTER
			tie: INTEGER
		do
			create lib.make
			lp := lib.lp_make_lp (0, 3)
			if lp = default_pointer then
				assert("Create model failed", false)
			end
			create row.make (8 * 4)
			row.put_real_64 (1, 0 + 8)
			row.put_real_64 (2, 0 + 8 * 2)
			row.put_real_64 (3, 0 + 8 * 3)
			tie := lib.lp_add_constraint (lp, row.item, 2, 3)
			if tie = 0 then
				assert("Add constraint failed", false)
			end
			lib.lp_delete_lp (lp)
		end

end
