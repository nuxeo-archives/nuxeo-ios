#!/bin/bash

HERE=$(cd $(dirname $0); pwd -P)
NX_INT=$HERE/download/nuxeo-integration
XCODEBUILD=${XCODEBUILD:-xcodebuild}

# Cleaning
rm -rf download nuxeo tomcat || exit 1

# Cloning integration-release
git clone https://github.com/nuxeo/integration-scripts $NX_INT

# Loading integration-lib.sh
. $NX_INT/integration-lib.sh

$NX_INT/download.sh

# Make wizard done.
echo "nuxeo.wizard.done=true" >> tomcat/bin/nuxeo.conf
start_server $HERE/tomcat 127.0.0.1

# Prepare CocoaPod workspace
./prepare-pod.sh

echo "Build: `type $XCODEBUILD`"
$XCODEBUILD -configuration Debug -workspace NuxeoSDK/NuxeoSDK.xcworkspace -scheme NuxeoSDK clean test
EXIT_CODE=$?

stop_server

exit $EXIT_CODE
