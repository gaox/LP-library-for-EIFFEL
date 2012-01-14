note
	description: "Run all the tests."
	author: "Xiang Gao"
	date: "$Date$"
	revision: "$Revision$"

class
	TESTSUITE

create
	make

feature {NONE} -- Initialization

	make
		do

		end

feature -- Run the tests

	execute
		local
			test: TEST
		do
			test := create {CACHE_TEST}.make
			test.run

			test := create {SOLVE_TEST}.make
			test.run

			test := create {SIMPLEX_TEST}.make
			test.run
		end
end
