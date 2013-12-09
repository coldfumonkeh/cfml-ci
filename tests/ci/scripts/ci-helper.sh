#!/bin/bash
# WORK_DIR and BUILD_DIR must be set!
if [ ! -n "$WORK_DIR" ]; then
	echo "WORK_DIR must be set!"
	exit 1
fi

if [ ! -n "$BUILD_DIR" ]; then
	BUILD_DIR=`pwd`
fi

echo "Working directory: $WORK_DIR, Build directory: $BUILD_DIR"

if [ ! "$1" == "install" ]; then

	if [ ! -d $WORK_DIR ]; then
		echo "Working directory doesn't exist and this isn't an install!"
		exit 1
	else
		cd $WORK_DIR
	fi
else
	if [ ! -n "$2" ]; then
		echo "usage: $0 install PROJECTNAME";
		exit 1
	fi
fi

case $1 in
	install)
		if [ -d $WORK_DIR ]; then
			rm -rf $WORK_DIR
		fi

		mkdir -p $WORK_DIR
		cd $WORK_DIR

		if [ ! -n "$RAILO_URL" ]; then
			RAILO_URL="http://getrailo.com/railo/remote/download/4.1.1.009/railix/linux/railo-express-4.1.1.009-nojre.tar.gz"
		fi

		if [ ! -n "$MXUNIT_URL" ]; then
			MXUNIT_URL="https://github.com/marcins/mxunit/archive/fix-railo-nulls.zip"
		fi

		WGET_OPTS="-nv"

		function download_and_extract {
			FILENAME=`echo $1|awk '{split($0,a,"/"); print a[length(a)]}'`
			if [[ "$1" == /* ]]; then
				echo "Copying $1 to $FILENAME"
				cp $1 $FILENAME
			else
				echo "Downloading $1 to $FILENAME"
				wget $WGET_OPTS $1 -O $FILENAME
			fi

			if [[ "$FILENAME" == *zip ]]; then
				unzip -q $FILENAME
			else
				tar -zxf $FILENAME
			fi
			rm $FILENAME
			result=$FILENAME
		}

		download_and_extract $RAILO_URL
		download_and_extract $MXUNIT_URL
		mv railo-express* railo
		mv mxunit* railo/webapps/www/mxunit

		ln -s $BUILD_DIR railo/webapps/www/$2
		;;
	start)
		if [ ! -f railo/start ]; then
			echo "Railo start script does not exist!"
			exit 1
		fi
		echo "Starting Railo..."
		sh railo/start>/dev/null &
		until curl -s http://localhost:8888>/dev/null
		do
			echo "Waiting for Railo..."
			sleep 1
		done
		;;
	stop)
		echo "Stopping Railo..."
		sh railo/stop
		while curl -s http://localhost:8888>/dev/null
		do
			echo "Waiting for Railo..."
			sleep 1
		done
		;;
	*)
		echo "Usage: $0 {install|start|stop}"
		exit 1
		;;
esac

exit 0