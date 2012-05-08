#!/bin/sh
#
# RequireJS's build script copies all extra unused JS files into the build
# directory, for some reason. This cleans up the extraneous files.

BUILD_SCRIPTS_DIR="build/scripts"

cd $BUILD_SCRIPTS_DIR && find . | \
    grep -v /main.js$ | \
    grep -v /libs/require/require.js$ | \
    grep -v /libs/require$ | \
    grep -v /libs$ | \
    grep -v "^.$" | \
    xargs rm -Rf
