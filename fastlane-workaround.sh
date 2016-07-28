#!/bin/sh

/bin/sh -c "sleep 60 ; killall Simulator" &
fastlane test

