#!/bin/sh
#
# Simple regression test script.  Builds and runs a test game, saving the
# output and comparing it to a reference transcript.  The reference transcript
# needs to have been previously captured via the capture_transcript.sh script.
#
# USAGE:
#
#	sh ./regression_test.sh [command file]
#
# If no command file is specified, command_file.txt will be used.
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
DIFF=${DIR}/diff.txt
LOG=${DIR}/transcript.txt

# Command file to use
CMDFILE="command_file.txt"

if [ "${1}" != '' ]; then
	CMDFILE=${1}
fi

if [ ! -f ${CMDFILE} ]; then
	echo "Command file ${CMDFILE} not found. "
	exit 1
fi

# Compile the T3 game.
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

# Run the game, capturing the output and then diff'ing it against the
# reference transcript.
run_game() {
	echo "Running game..."
	cp command_file.txt ${GAME_DIR}
	cd ${DEMO_DIR}
	${FROB} --no-pause --replay ${CMDFILE} --interface plain ${GAME} > ${OUT}
	cd ${DIR}
	echo "...done."
	diff ${LOG} ${OUT} > ${DIFF} 2>&1
	LC=`cat ${DIFF}|wc -l`
	if [ ${LC} -ne 0 ]; then
		echo "FAILURE"
		echo "Transcript diff contained ${LC} lines."
		echo "Check ${DIFF} for detailed."
		exit 1
	fi
	echo "No differences in transcript, success."
}

run_build
run_game

exit 0
