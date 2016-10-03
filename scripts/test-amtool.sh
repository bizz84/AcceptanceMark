#!/bin/bash

xcodebuild test -project AcceptanceMark.xcodeproj -scheme amtool-tests -sdk macosx10.12 ONLY_ACTIVE_ARCH=NO

