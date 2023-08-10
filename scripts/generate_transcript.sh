#!/bin/sh
#
# Shell script to build and run a demo game, capturing the transcript
# for later use as a baseline.
#
# USAGE:
#
#	sh ./generate_transcript.sh [options]
#
#		--command-file		File name of command file
#						default: command_file.txt
#		--game-file		File name of game story file
#						default: regression.t3
#		--make-file		File name of TADS makefile
#						default: regression.t3m
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
GAMEFILE=game.t3
MAKEFILE=makefile.t3m

# Directory the script is run from.
DIR=`pwd`
DATA_DIR=${DIR}/../data
OUT=${DATA_DIR}/transcript.txt

# Default command file to use.
CMDFILE="command_file.txt"

print_usage() {
	echo "Usage:"
	echo ""
	echo "     $0 [options]"
	echo ""
	echo "          --command-file [name]"
	echo "               File name for command file (default: command_file.txt)"
	echo "          --game-file [name]"
	echo "               File name for game file (default: game.t3)"
	echo "          --make-file [name]"
	echo "               File name for makefile (default: makefile.t3m)"
	echo ""
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

if [ "${1}" != '' ]; then
	CMDFILE=${1}
fi

if [ ! -f ${DATA_DIR}/${CMDFILE} ]; then
	echo "Command file ${DATA_DIR}/${CMDFILE} not found. "
	exit 1
fi

# Compile the TADS3 game.
run_build() {
	echo "Making game..."
	cd ${DEMO_DIR}
	${T3MAKE} -d -a -q -f ${MAKEFILE} >/dev/null 2>&1
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
	${FROB} --no-pause --interface plain --replay ${CMDFILE} ${GAME_DIR}/${GAMEFILE}  > ${OUT}
	cd ${DIR}
	echo "...done."
	echo "Transcript saved to ${OUT}"
}

run_build
run_game

exit 0
