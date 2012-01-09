note
	description : "EIFLP application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	execute

feature {NONE} -- Initialization

	execute
			-- Run all the tests.
		local
			testsuite: TESTSUITE
		do
			create testsuite.make
			testsuite.execute
		end

end
