#!/bin/sh
#
# Simple regression test script.  Builds and runs a test game, saving the
# output and comparing it to a reference transcript.  The reference transcript
# needs to have been previously captured via the capture_transcript.sh script.
#
# The TADS3 code used for this script should include whatever modules and
# modifications to adv3 that you want to test.
#

# FrobTADS interpreter binary
FROB=/usr/local/bin/frob

# FrobTADS compiler binary
T3MAKE=/usr/local/bin/t3make

# Location of the demonstration game.
DEMO_DIR=../demo
GAME_DIR=../demo/games
GAME=${GAME_DIR}/game.t3

# Directory the script is run from.
DIR=`pwd`
OUT=${GAME_DIR}/output.txt
LOG=${DIR}/transcript.txt

# Compile the T3 game.
run_build() {
	cd ${DEMO_DIR}
	${T3MAKE} -d -a -f makefile.t3m >/dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo "Error running ${T3MAKE}"
		exit 1
	fi
	cd ${DIR}
}

# Run the game, capturing the output and then diff'ing it against the
# reference transcript.
run_game() {
	cp command_file.txt ${GAME_DIR}
	cd ${DEMO_DIR}
	${FROB} --no-pause --replay command_file.txt --interface plain ${GAME} > ${OUT}
	cd ${DIR}
	diff ${LOG} ${OUT}
}

run_build
run_game

exit 0
