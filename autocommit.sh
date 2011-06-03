#!/bin/bash

VAR="`date '+%A %d %B %Y @ %Hh%M'`"
hg add
hg commit -m "${VAR} - commit auto"