#charset "us-ascii"
//
// sample.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the regressionTest library.
// It is designed to exercise basic parser functionality, running
// non-interactively from a script.
//
// It can be compiled via the included makefile with
//
//	# t3make -f makefile.t3m
//
// ...or the equivalent, depending on what TADS development environment
// you're using.
//
// This "game" is distributed under the MIT License, see LICENSE.txt
// for details.
//
#include <adv3.h>
#include <en_us.h>

#include "regressionTest.h"

modify startRoom;
+me: Person;

gameMain: GameMainDef initialPlayerChar = me;
versionInfo: GameID;
