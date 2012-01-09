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
			test := create {CACHETEST}.make
			test.run

			test := create {SOLVETEST}.make
			test.run
		end
end
