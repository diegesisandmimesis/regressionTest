#!/bin/sh
#
# Shell script to build and run a demo game, capturing the transcript
# for later use as a baseline.
#
# USAGE:
#
#	sh ./capture_transcript.sh [command file]
#
# If no command file is specified, command_file.txt will be used.
#
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
DATA_DIR=${DIR}/../data
OUT=${DATA_DIR}/transcript.txt

# Default command file to use.
INFILE="command_file.txt"

if [ "${1}" != '' ]; then
	INFILE=${1}
fi

if [ ! -f ${INFILE} ]; then
	echo "Command file ${INFILE} not found. "
	exit 1
fi

# Compile the TADS3 game.
run_build() {
	echo "Making game..."
	cd ${DEMO_DIR}
	${T3MAKE} -d -a -f makefile.t3m >/dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo "Error running ${T3MAKE}"
		exit 1
	fi
	cd ${DIR}
	echo "...done."
}

# Run the game, redirecting the output to a file
run_game() {
	echo "Running game..."
	cp ${DATA_DIR}/command_file.txt ${GAME_DIR}
	cd ${DEMO_DIR}
	${FROB} --no-pause --interface plain --replay ${INFILE} ${GAME}  > ${OUT}
	cd ${DIR}
	echo "...done."
	echo "Transcript saved to ${OUT}"
}

run_build
run_game

exit 0
