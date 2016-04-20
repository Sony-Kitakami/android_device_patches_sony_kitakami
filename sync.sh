#!/bin/bash

LOCAL_PATH=$(dirname $(readlink -f $0))
TOP=${LOCAL_PATH}/../../../..

TORCH_DIR=${TOP}/frameworks/base/packages/SystemUI/src/com/android/systemui/qs/tiles
RVRT_TORCH_DIR=${TORCH_DIR}/backup

VOLD_DIR=${TOP}/system/vold
RVRT_VOLD_DIR=${VOLD_DIR}/backup

PATCHED_VOLD_DIR=${LOCAL_PATH}/patched/system/vold
PATCHED_TORCH_DIR=${LOCAL_PATH}/patched/frameworks/base/packages/SystemUI/src/com/android/systemui/qs/tiles

echo "Checking if patches have been overwritten by updates"

if ! (grep -Fq "THIS FILE HAS BEEN PATCHED" system/vold/Utils.cpp); then
	mv ${VOLD_DIR}/Utils.cpp ${RVRT_VOLD_DIR}/
	cp ${PATCHED_VOLD_DIR}/Utils.cpp ${VOLD_DIR}/
fi

if ! (grep -Fq "THIS FILE HAS BEEN PATCHED" ${VOLD_DIR}/Android.mk); then
	mv ${VOLD_DIR}/Android.mk ${RVRT_VOLD_DIR}/
	cp ${PATCHED_VOLD_DIR}/Android.mk ${VOLD_DIR}/
fi

#-----------------------------------------------------------------------------------

if ! (grep -Fq "THIS FILE HAS BEEN PATCHED" ${TORCH_DIR}/FlashlightTile.java); then
	mv ${TORCH_DIR}/FlashlightTile.java ${RVRT_TORCH_DIR}/
	cp ${PATCHED_TORCH_DIR}/FlashlightTile.java ${TORCH_DIR}/
fi