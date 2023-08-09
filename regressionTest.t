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
//	Now run the generate_transcript.sh script.  The default usage:
//
//		sh ./generate_transcript.sh
//
//	...should work for most purposes.  This will read commands from
//	./data/command_file.txt, and write the transcript to
//	./data/transcript.txt.  If you need/want to override the defaults,
//	read the comments at the top of the script for more detailed
//	usage information.
//
//
//	RUNNING A REGRESSION TEST
//
//	Once you have a command file and a transcript you can use them to
//	run a regression test on an existing game.
//
//	To do this, you first need to compile the game to include this
//	module.  This should require nothing more than adding
//
//		-lib [path to this module]/regressionTest
//
//	to the the makefile.  You also should include a line containing
//
//		-D REGRESSION_TEST
//
//	to enable the module.  The REGRESSION_TEST flag enables all the
//	code in this module, to make it easier to recompile with or
//	without the testing code as needed.
//
//	To run a test you can use the ./scripts/regression_test.sh script.
//	It assumes a source layout similar to this module's:  it expects
//	a directory called ./demo containing a ./demo/games subdirectory,
//	which is where the game binary will be.  If that's NOT how your
//	game's source is layed out, you can just replace the values of
//	SRC_DIR and GAME_DIR in ./scripts/regression_test.sh to reflect
//	the locations used by your game.
//
//	The usage is:
//
//		sh ./regression_test.sh [command file]
//
//	If no command file is given, command_file.txt (in the directory
//	the script is run from) will be used instead.
//
//	The script will compile the game and then run it with the same
//	settings as the ./scripts/generate_transcript.sh script.  It will
//	then compare the test transcript and the reference transcript
//	and either report success if there are no differences, or failure
//	if there are.  The diff of the two transcripts will be output
//	to diff.txt in the directory the script is run from.
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
