#charset "us-ascii"
//
// regressionTest.t
//
//	A framework for simple modular regression testing.
//
//	The module provides a simple, self-contained gameworld
//	which (hopefully) can co-exist with a "real" gameworld.
//	This in principle allows the regression testing module to be
//	compiled into an existing game with no modification.  The
//	compiled game can then be tested with via a command file, and
//	the output compared to a reference transcript.
//
//
// 	BUILDING TEST CASES
//
//	The game world provided is fairly minimal, but can be expanded
//	to include whatever features you want to test.  The game world
//	definition lives in regressionTestGameWorld.t
//
//	The module supplies a PreinitObject that makes the
//	regressionTestPlayer object the player character.  It starts
//	out in regressionTestStartRoom.  So if you add new locations,
//	just make sure they're contiguous with regressionTestStartRoom.
//
//	With the exception of the player object, an attempt has been
//	made to use as many anonymous objects as possible, to avoid
//	potential collisions with names in the game being tested.
//
//
//	GENERATING A COMMAND FILE
//
//	To generate a command file you can first compile the
//	regressionTest demo game (which is barebones and changes none
//	of the default parser behavior).  To do this, in the ./demo
//	directory, use:
//
//		# t3make -a -f makefile.t3m
//
//	This will create the game file in ./demo/games/game.t3.  Having
//	done this, you can create a command file by using the >RECORD
//	command when in the game.  For example, from the ./demo
//	directory:
//
//		# frob ./games/game.t3
//
//			Start Room
//			This is the start room.  The pebble room lies to the
//			north.
//
//			>record
//			Please select a name for the new command log file >
//
//	Enter a file name, and then do whatever commands you want to
//	test.  When you're done, instead of using >RECORD OFF to end the
//	command file, use >QUIT to exit the game.  This is so the 
//	test case will automagically exit as well.  If you DON'T do this,
//	you can manually add lines to accomplish the same thing to the
//	end of the command file:
//
//		>quit
//		>y
//
//
//	GENERATING A REFERENCE TRANSCRIPT
//
//	Once you have a command file you can use it to generate a reference
//	transcript.  First, go to the ./scripts directory.
//
//	Now run the capture_transcript.sh script.  The usage is
//
//		sh ./capture_transcript.sh [command file]
//
//	The argument is optional;  if you run the script with no arguments it
//	will read commands from ./scripts/command_file.txt.
//
//	The script will write a transcript to ./scripts/transcript.txt.
//
#include <adv3.h>
#include <en_us.h>

#ifdef REGRESSION_TEST

// Module ID for the library
regressionTestModuleID: ModuleID {
        name = 'Regression Test Library'
        byline = 'Diegesis & Mimesis'
        version = '1.0'
        listingOrder = 99
}

PreinitObject
	execute() {
		initPlayer();
	}

	// Make the test player the current player character.
	initPlayer() {
		gPlayerChar = regressionTestPlayer;
	}
;

#endif // REGRESSION_TEST
