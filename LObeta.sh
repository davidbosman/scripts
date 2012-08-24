#!/bin/sh
MY_CONF=file:///home/david/.libreoffice/35/
/opt/lodev3.5/program/soffice -env:UserInstallation=${MY_CONF} "$@"
