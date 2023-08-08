#!/bin/sh
#
# Shell script to build and run a demo game, capturing the transcript
# for later use as a baseline.
#
# This should be run on a demo with few or no changes to stock adv3
# behavior.
#

# FrobTADS interpreter binary
FROB=/usr/local/bin/frob

# FrobTADS compiler binary
T3MAKE=/usr/local/bin/t3make

# Place where the demo stuff lives
DEMO_DIR=../demo
GAME_DIR=../demo/games
GAME=${GAME_DIR}/game.t3

# Directory the script is run from.
DIR=`pwd`
OUT=${DIR}/transcript.txt

# Compile the TADS3 game.
run_build() {
	cd ${DEMO_DIR}
	${T3MAKE} -d -a -f makefile.t3m >/dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo "Error running ${T3MAKE}"
		exit 1
	fi
	cd ${DIR}
}

# Run the game, redirecting the output to a file
run_game() {
	cp command_file.txt ${GAME_DIR}
	cd ${DEMO_DIR}
	${FROB} --no-pause --interface plain --replay command_file.txt ${GAME}  > ${OUT}
	cd ${DIR}
}

run_build
run_game

exit 0
