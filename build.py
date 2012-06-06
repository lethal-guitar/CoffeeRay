#!/usr/bin/python

import os
import sys

buildfile = open("build-order.txt", "r")
compiler = "coffee"
outFile = "web/coffee-ray.js"

if len(sys.argv) > 1:
  compiler = sys.argv[1]  

sourceFiles = []

for line in buildfile:
    sourceFiles.append("src/" + line[:-1])
    
inFiles = " ".join(sourceFiles)

finalCmd = compiler + " -j " + outFile + " -c " + inFiles
os.system(finalCmd)
