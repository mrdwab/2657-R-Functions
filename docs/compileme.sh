#!/bin/bash

pandoc \
Part*.md \
-o 2657-Functions.pdf \
-V documentclass:book \
-V geometry:a4paper \
-V geometry:margin=1in \
-V linkcolor:black
