note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_CACHE

inherit
	EQA_TEST_SET

feature -- Test routines

	test_cache_1
			-- New test routine
		note
			testing:  "cache"
		local
			-- LP library
			lib: LPLIB

			-- Build the model
			lp1: POINTER
			lp2: POINTER
			lp3: POINTER
			filename: C_STRING
			modelname: C_STRING
			model1: MODEL
			model2: MODEL
			model3: MODEL
		do
			io.put_string ("-----Start running cachetest%N")
			create lib.make
			create filename.make ("C:\Users\thinkpad\Documents\Eiffel 6.8 User Files\projects\EIFLP\EIFLP\testcase\1.lp")
			create modelname.make ("1.model")
			lp1 := lib.lp_read_lp(filename.item, 4, modelname.item)
			lp2 := lib.lp_read_lp(filename.item, 4, modelname.item)
			create model1.make (lp1, lib)
			create model2.make (lp2, lib)
			model1.solve (lp1, lib)

			lib.insert_to_cache (model1)
			if lib.search_cache (model2) /= Void then
				io.put_string ("Hit cache!%N")
			else
				io.put_string ("Error: should hit the cache%N")
				assert("Error: should hit the cache", false)
			end

			create filename.make ("C:\Users\thinkpad\Documents\Eiffel 6.8 User Files\projects\EIFLP\EIFLP\testcase\2.lp")
			create modelname.make ("2.model")
			lp3 := lib.lp_read_lp(filename.item, 4, modelname.item)
			create model3.make (lp3, lib)
			if lib.search_cache (model3) /= Void then
				io.put_string ("Error: should miss the cache%N")
				assert("Error: should miss the cache", false)
			else
				io.put_string ("Miss cache%N")
			end
			io.put_string ("*****Finish cachetest%N")
			io.new_line

			lib.lp_delete_lp (lp1)
			lib.lp_delete_lp (lp2)
			lib.lp_delete_lp (lp3)
		end

end
