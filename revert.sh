#!/bin/bash

LOCAL_PATH=$(dirname $(readlink -f $0))
TOP=$LOCAL_PATH/../../../..

FRAMEWORKS_BASE_DIR=${TOP}/frameworks/base
TORCH_DIR=${TOP}/frameworks/base/packages/SystemUI/src/com/android/systemui/qs/tiles
VOLD_DIR=${TOP}/system/vold


PATCHED_VOLD_DIR=${LOCAL_PATH}/patched/system/vold
PATCHED_TORCH_DIR=${LOCAL_PATH}/patched/frameworks/base/packages/SystemUI/src/com/android/systemui/qs/tiles

if [ -f ${LOCAL_PATH}/PATCHED ]; then
 
	echo "Not building kitakami! Reverting kitakami patches!"
   
	rm ${LOCAL_PATH}/PATCHED
   
	echo "Reverting vold patches!"
   
	rm -R ${VOLD_DIR}

	echo "Reverting Flashlight patches!"

	rm -R ${FRAMEWORKS_BASE_DIR}

	echo "Fetching unpatched versions!"

	eval "repo sync --force-sync"

	echo "Patches reverted!"

fi
