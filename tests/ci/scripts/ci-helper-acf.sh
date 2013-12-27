#!/bin/bash
# WORK_DIR and BUILD_DIR must be set!

CONTROL_SCRIPT='coldfusion10/cfusion/bin/coldfusion'

MY_DIR=`dirname $0`
source $MY_DIR/ci-helper-base.sh $1 $2

case $1 in
	install)
		mv mxunit* coldfusion10/cfusion/wwwroot/mxunit

		ln -s $BUILD_DIR coldfusion10/cfusion/wwwroot/$2

		echo "Fixing ACF install directory..."
		LC_CTYPE=C find ./ -type f -exec sed -i'' -e 's/\/opt\/coldfusion10\//\/tmp\/work\/coldfusion10\//g' {} \;

		# TODO modify port in cfusion/runtime/conf/server.xml
		sed -i "s/8500/$SERVER_PORT/g" coldfusion10/cfusion/runtime/conf/server.xml
		;;
	start|stop)
		;;
	*)
		echo "Usage: $0 {install|start|stop}"
		exit 1
		;;
esac

exit 0