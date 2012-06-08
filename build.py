#!/usr/bin/python

# Build script - it scans build-order.txt and passes 
# all files found in there to the coffeescript compiler, in
# the same order as specified.
# 
# The compiler command is "coffee" by default, it may 
# be overriden like so:
#
#   build.py <COMPILER_COMMAND>

import os
import sys

buildfile = open("build-order.txt", "r")
compiler = "coffee"
outFile = "web/coffee-ray.js"

if len(sys.argv) > 1:
  compiler = sys.argv[1]  

sourceFiles = ["src/" + line[:-1] for line in buildfile]
filesInCmd = " ".join(sourceFiles)

finalCmd = compiler + " -j " + outFile + " -c " + filesInCmd
os.system(finalCmd)
