#!/bin/sh

#track parts
(cd track && /bin/sh compile_scads.sh)

#boats
(cd boats && /bin/sh compile_scads.sh)
