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

# Locations for the demonstration game.
#
# Top-level of the game source.
SRC_DIR=../demo
#
# Directory containing the compiled game.  The command file will
# be copied here (because frob will look for it in the same directory
# as the story file) and the transcript will be written here.
GAME_DIR=../demo/games
#
# Path to the story file.
GAME=${GAME_DIR}/game.t3
#
# Directory the script is run from.
DIR=`pwd`

# Locations for the script files
#
# Filename to use for the test transcript.
OUT=${GAME_DIR}/output.txt
#
# Filename of the reference transcript to compare against.
LOG=${DIR}/transcript.txt
#
# Filename to use for the diff of the test and reference transcripts.
DIFF=${DIR}/diff.txt
#
# Command file to use
CMDFILE="command_file.txt"

# Use the first argument, if given, as the command file.
if [ "${1}" != '' ]; then
	CMDFILE=${1}
fi

# Make sure the command file exits.
if [ ! -f ${CMDFILE} ]; then
	echo "Command file ${CMDFILE} not found. "
	exit 1
fi

# Compile the game.
run_build() {
	echo "Making game..."
	cd ${SRC_DIR}
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

	# Move the command file to the game directory.  Required by frob.
	cp command_file.txt ${GAME_DIR}

	# Go to the top of the source tree.
	cd ${SRC_DIR}
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
