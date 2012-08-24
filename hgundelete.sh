#!/bin/sh
hg log --template "{rev}: {file_dels}\n" | grep -v ':\s*$' | grep $1
