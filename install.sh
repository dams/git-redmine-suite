#!/bin/bash

GIT_REQUIRED_VERSION=1.7

echo "Checking git version ..."
echo ""
echo "Required : $GIT_REQUIRED_VERSION"

GIT_VERSION=$(git version | /usr/bin/perl -pe 's/.*?(\d+\.\d+).*/$1/')
echo "Version  : $GIT_VERSION"
echo ""

if [ -z "$GIT_VERSION" ]; then
	echo "Unable to detect git version"
	echo "Canceling installation ..."
	echo ""
	exit 1
fi

GIT_VERSION_OK=$(echo "$GIT_VERSION >= $GIT_REQUIRED_VERSION" | bc)
if [ "$GIT_VERSION_OK" = "0" ]; then
	echo "You need at least git version $GIT_REQUIRED_VERSION !"
	echo "Canceling installation ..."
	echo ""
	exit 1
fi

cd "$(dirname "$0")"
if [ -z "$SKIP_CPANM" ]; then
	if ! sudo HOME=/tmp PERL_CPANM_OPT="" ./cpanm -nv Redmine::API Moo MooX::Options LWP::Protocol::https Version::Next DateTime Term::ReadLine Date::Parse LWP::Curl List::MoreUtils List::Util List::Util::XS autodie utf8::all Term::Size Digest::MD5 Data::UUID JSON::XS URI::Escape IO::Interactive; then
		echo "Fail to install dependencies !"
		exit 1
	fi
fi

sudo rm -rf /usr/local/share/Git-Redmine-Suite /usr/local/bin/git-redmine /usr/local/bin/git-redmine-*

sudo cp -RvL share/* /usr/local/share/
sudo cp -av bin/* /usr/local/bin/

sudo chown -R 0:0 /usr/local/share/Git-Redmine-Suite/ /usr/local/bin/git-redmine /usr/local/bin/git-redmine-*
sudo chmod -R 755 /usr/local/share/Git-Redmine-Suite/ /usr/local/bin/git-redmine /usr/local/bin/git-redmine-*

if [ -n "$CURPWD" ] && [ -n "$1" ]
then
	echo ""
	echo "Move to $CURPWD"
	cd "$CURPWD"
	echo ""
	echo "Run : $*"
	echo ""
	exec $*
fi
