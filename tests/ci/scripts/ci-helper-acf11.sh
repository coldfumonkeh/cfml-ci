#!/bin/bash
CONTROL_SCRIPT='coldfusion11/cfusion/bin/coldfusion'

PLATFORM_DIR="coldfusion11"
WEBROOT="coldfusion11/cfusion/wwwroot"
MY_DIR=`dirname $0`
source $MY_DIR/ci-helper-base.sh $1 $2

case $1 in
	install)
		echo "Fixing ACF install directory..."
		grep -rl "/opt/coldfusion11/" --exclude-dir=$WEBROOT . | xargs -n 1 sed -i "s#/opt/coldfusion11/#$WORK_DIR/coldfusion11/#g"

		sed -i "s/8500/$SERVER_PORT/g" coldfusion11/cfusion/runtime/conf/server.xml
		;;
	start|stop)
		;;
	*)
		echo "Usage: $0 {install|start|stop}"
		exit 1
		;;
esac

exit 0
