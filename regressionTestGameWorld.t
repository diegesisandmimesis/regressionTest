#charset "us-ascii"
//
// regressionTestGameWorld.t
//
//	A simple game world for use in regression testing.
//
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

#endif // REGRESSION_TEST
