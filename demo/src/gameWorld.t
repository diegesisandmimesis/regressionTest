#charset "us-ascii"
//
// gameWorld.t
//
//	A simple game world used in the tests.
//
#include <adv3.h>
#include <en_us.h>

#include "regressionTest.h"

startRoom: Room 'Start Room'
	"This is the start room.  The pebble room lies to the north. "
	north = pebbleRoom
;

pebbleRoom: Room 'Pebble Room'
	"This is the pebble room.  There are exits to the north and south. "
	north = stoneRoom
	south = startRoom
;
+pebble: Thing 'small round pebble' 'pebble' "A small, round pebble. ";

stoneRoom: Room 'Stone Room'
	"This is the stone room.  There are exits to the north and south. "
	north = aliceRoom
	south = pebbleRoom
;
+blackStone: Thing '(black) (go) stone' 'black go stone' "A black go stone. ";
+whiteStone: Thing '(white) (go) stone' 'white go stone' "A white go stone. ";

aliceRoom: Room 'Alice\'s Room'
	"This is Alice\'s room.  There is an exit to the south. "
	south = stoneRoom
;
+alice: Person 'Alice' 'Alice'
	"She looks like the first person you'd turn to in a problem. "
	isHer = true
	isProperName = true
;
++pebbleTopic: Topic 'pebble';
++AskTellTopic @pebbleTopic
	"<q>This space intentionally left blank,</q> Alice says. "
;
