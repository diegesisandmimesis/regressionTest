#!/usr/bin/env bash
#
# Simple regression test script.  Builds and runs a test game, saving the
# output and comparing it to a reference transcript.  The reference transcript
# needs to have been previously captured via the capture_transcript.sh script.
#
# USAGE:
#
#	sh ./regression_test.sh [options]
#
#		--command-file		File name of command file
#					default: command_file.txt
#		--game-file		File name of game story file
#					default: regression.t3
#		--make-file		File name of TADS makefile
#					default: regression.t3m
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
# Directory the script is run from.
DIR=`pwd`
#
# Directory the script lives in
SCRIPT_DIR=$(dirname $0)
#
# Directory configuration files live in
DATA_DIR=${SCRIPT_DIR}/../data
#
# Top-level of the game source.
SRC_DIR=${DIR}/../demo
#
# Directory containing the compiled game.  The command file will
# be copied here (because frob will look for it in the same directory
# as the story file) and the transcript will be written here.
GAME_DIR=${DIR}/../demo/games
#
# Path to the story file.
GAMEFILE=regression.t3
#
# Makefile filename
MAKEFILE=regression.t3m

# Locations for the script files
#
# Filename to use for the test transcript.
OUT=${GAME_DIR}/output.txt
#
# Filename of the reference transcript to compare against.
LOG=${DATA_DIR}/transcript.txt
#
# Filename to use for the diff of the test and reference transcripts.
DIFF=${DATA_DIR}/diff.txt
#
# Command file to use
CMDFILE=${DATA_DIR}/command_file.txt

print_usage() {
	echo "Usage:  ${0}"
}

while :; do
	case $1 in
		-h|-\?|--help)
			print_usage
			exit 0
			;;
		-c|--command-file|--commandfile)
			if [ "$2" ]; then
				CMDFILE=$2
				shift
				shift
			else
				echo "Error:  --command-file requires an argument."
				exit 1
			fi
			;;
		-m|--make-file|--makefile)
			if [ "$2" ]; then
				MAKEFILE=$2
				shift
				shift
			else
				echo "Error:  --make-file requires an argument."
				exit 1
			fi
			;;
		-g|--game-file|--gamefile)
			if [ "$2" ]; then
				GAMEFILE=$2
				shift
				shift
			else
				echo "Error:  --game-file requires an argument."
				exit 1
			fi
			;;
		--)
			shift
			break
			;;
		-?*)
			echo "Error:  Unknown option: $1"
			exit 1
			;;
		*)
			break
	esac
done

validate_args() {
	# Make sure the command file exits.
	if [ ! -f ${CMDFILE} ]; then
		echo "Command file ${CMDFILE} not found. "
		exit 1
	fi
}


# Compile the game.
run_build() {
	echo "Making game..."
	cd ${SRC_DIR}
	#${T3MAKE} -d -a -q -f ${MAKEFILE} >/dev/null 2>&1
	${T3MAKE} -d -a -q -f ${MAKEFILE}
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
	cp ${CMDFILE} ${GAME_DIR}

	# Go to the top of the source tree.
	cd ${SRC_DIR}
	${FROB} --no-pause --replay $(basename ${CMDFILE}) --interface plain ${GAME_DIR}/${GAMEFILE} > ${OUT}
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

validate_args
run_build
run_game

exit 0
