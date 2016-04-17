#!/bin/bash

LOCAL_PATH=$(dirname $(readlink -f $0))
TOP=$LOCAL_PATH/../../../..

FRAMEWORKS_BASE_DIR=${TOP}/frameworks/base
TORCH_DIR=${TOP}/frameworks/base/packages/SystemUI/src/com/android/systemui/qs/tiles
VOLD_DIR=${TOP}/system/vold


PATCHED_VOLD_DIR=${LOCAL_PATH}/patched/system/vold
PATCHED_TORCH_DIR=${LOCAL_PATH}/patched/frameworks/base/packages/SystemUI/src/com/android/systemui/qs/tiles

if [ ! -f {LOCAL_PATH}/PATCHED ]; then

	touch ${LOCAL_PATH}/PATCHED

	echo "Applying Vold patch!"

	rm ${VOLD_DIR}/Utils.cpp
	rm ${VOLD_DIR}/Android.mk

	cp ${PATCHED_VOLD_DIR}/Utils.cpp ${VOLD_DIR}/
	cp ${PATCHED_VOLD_DIR}/Android.mk ${VOLD_DIR}/

	echo "Applying torch patch!"

	rm ${TORCH_DIR}/FlashlightTile.java

	cp ${PATCHED_TORCH_DIR}/FlashlightTile.java ${TORCH_DIR}/

fi