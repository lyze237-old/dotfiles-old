#!/bin/bash

echo "Running owl.sh with arguments '$*'"

case "$1" in
	"install")
		echo "Running xbps-install -S ${*:2}"
		
		if ! xbps-install -S "${@:2}" ; then
			exit 20
		fi
		;;
	"update")
		echo "Running xbps-install -S"
		
		if ! xbps-install -S ; then
			exit 30
		fi
		;;
	"upgrade")
		echo "Running xbps-install -u"
		
		if ! xbps-install -u ; then
			exit 40
		fi
		;;
	"search")
		echo "Running xbps-query -Rs ${*:2}"
		
		if ! xbps-query -Rs "${@:2}" ; then
			exit 50
		fi
		;;
	"autoremove")
		echo "Running xbps-remove -o"
		
		if ! xbps-remove -o ; then
			exit 60
		fi
		;;
	"--fix-broken")
		echo "Running xbps-pkgdb -a"
		
		if ! xbps-pkgdb -a ; then
			exit 70
		fi
		;;
	"init")
		echo "Initializing void-packages repo"
		curDir=$(pwd)
		cd /tmp/ || exit 80
		
		echo "Cloning void-packages to /tmp/void-packages/"
		
		if ! git clone https://github.com/voidlinux/void-packages.git ; then
			echo "Couldn't download void packages to /tmp/"
			exit 81
		fi
		
		cd /tmp/void-packages/ || exit 82
		
		echo "Executing binary-bootstrap"
		
		
		if ! ./xbps-src binary-bootstrap	 ; then
			cd "$curDir" || exit 83
			exit 84
		fi
		
		cd "$curDir" || exit 85
		;;
	"build")
		echo "Building $2 with xbps-src"
		curDir=$(pwd)
		cd /tmp/void-packages/ || exit 90
		
		echo "Running ./xbps-src -f pkg $2"
		
		if ! ./xbps-src -f pkg "$2" ; then
			cd "$curDir" || exit 91
			exit 92
		fi
		
		cd "$curDir" || exit 93
		;;
	*)
		echo "owl.sh xbps package manager wrapper"
		echo "* install <packages>  Installs <packages>"
		echo "* update              Updates repositories"
		echo "* upgrade             Upgrades packages"
		echo "* search <package>    Searches for package"
		echo "* autoremove          Removes dependencies that are no longer needed"
		echo "* --fix-broken        Uses some magic to fix broken dependencies" 
		
		exit 10
		;;
esac
