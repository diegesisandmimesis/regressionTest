#charset "us-ascii"
//
// regressionTestGameWorld.t
//
//	A simple game world for use in regression testing.
//
//	Design notes:
//
//		-All the test rooms are contiguous with the other test rooms
//		 (there's a path from each room to each other room)
//		-Whenever possible objects are declared anonymously, to
//		 minimize the potential for name collisions with names in
//		 the "real" game being tested
//		-A separate test player is used to avoid having to fiddle
//		 with the "real" player character
//		-The entire game world (like all the code in this module)
//		 is wrapped in a preprocessor conditional so that everything
//		 can be toggled by compiling with or without
//		 -D REGRESSION_TEST
//
#include <adv3.h>
#include <en_us.h>

#include "regressionTest.h"

#ifdef REGRESSION_TEST

regressionTestStartRoom: Room 'Start Room'
	"This is the start room.  The pebble room lies to the north. "
	north = regressionTestPebbleRoom
;
+regressionTestPlayer: Person;

regressionTestPebbleRoom: Room 'Pebble Room'
	"This is the pebble room.  There are exits to the north and south. "
	north = regressionTestStoneRoom
	south = regressionTestStartRoom
;
+Thing 'small round pebble' 'pebble' "A small, round pebble. ";

regressionTestStoneRoom: Room 'Stone Room'
	"This is the stone room.  There are exits to the north and south. "
	north = regressionTestAliceRoom
	south = regressionTestPebbleRoom
;
+Thing '(black) (go) stone' 'black go stone' "A black go stone. ";
+Thing '(white) (go) stone' 'white go stone' "A white go stone. ";

regressionTestAliceRoom: Room 'Alice\'s Room'
	"This is Alice\'s room.  There is an exit to the south. "
	north = regressionTestBobRoom
	south = regressionTestStoneRoom
;
+Person 'Alice' 'Alice'
	"She looks like the first person you'd turn to in a problem. "
	isHer = true
	isProperName = true
;
++regressionTestPebbleTopic: Topic 'pebble';
++AskTellTopic @regressionTestPebbleTopic
	"<q>This space intentionally left blank,</q> Alice says. "
;

regressionTestBobRoom: Room 'Bob\'s Room'
	"This is Bob\'s room.  There is an exit to the south. "
	south = regressionTestAliceRoom
;
+Person 'Bob' 'Bob'
	"He looks like a Robert, only shorter. "
	isHim = true
	isProperName = true

	obeyCommand(fromActor, action) {
		if(action && action.ofKind(TakeAction))
			return(true);
		return(inherited(fromActor, action));
	}
;
+Thing '(nondescript) rock' 'rock' "A nondescript rock. ";

#endif // REGRESSION_TEST
