#!/bin/bash

LOCAL_PATH=$(dirname $(readlink -f $0))
TOP=$LOCAL_PATH/../../../..

TORCH_DIR=${TOP}/frameworks/base/packages/SystemUI/src/com/android/systemui/qs/tiles
RVRT_TORCH_DIR=${TORCH_DIR}/backup

VOLD_DIR=${TOP}/system/vold
RVRT_VOLD_DIR=${VOLD_DIR}/backup

PATCHED_VOLD_DIR=${LOCAL_PATH}/patched/system/vold
PATCHED_TORCH_DIR=${LOCAL_PATH}/patched/frameworks/base/packages/SystemUI/src/com/android/systemui/qs/tiles

function make_patch_stamp
{
	# Echo patch list ($1 = Files, $2 = path/to/patchlist)
	echo "$1" > $2/patchlist

	# Echo device mark 
	echo "kitakami" > $2/patch-device
}

if [ ! -f {LOCAL_PATH}/PATCHED ]; then

	touch ${LOCAL_PATH}/PATCHED

	echo "Applying Vold patch!"

	if [ ! -f ${VOLD_DIR}/patchlist ]; then
		make_patch_stamp 'Utils.cpp Android.mk' ${VOLD_DIR}
	fi

	# Move original/untouched/un-patched files to backup dir
	if [ ! -d ${RVRT_VOLD_DIR} ]; then

		mkdir ${RVRT_VOLD_DIR}
		echo "THIS DIR CONTAINS UNTOUCHED/UNPATCHED FILES, DO NOT REMOVE! THIS DIR WILL GET REMOVED AUTOMATICALLY IF NECCESSARY" > ${RVRT_VOLD_DIR}/README
		mv ${VOLD_DIR}/Utils.cpp ${RVRT_VOLD_DIR}/
		mv ${VOLD_DIR}/Android.mk ${RVRT_VOLD_DIR}/
	
	fi

	# Copy patched files to CM source
	cp ${PATCHED_VOLD_DIR}/Utils.cpp ${VOLD_DIR}/
	cp ${PATCHED_VOLD_DIR}/Android.mk ${VOLD_DIR}/

	echo "Applying torch patch!"

	if [ ! -f ${TORCH_DIR}/patchlist ]; then
		make_patch_stamp 'FlashlightTile.java' ${TORCH_DIR}
	fi

	# Move original/untouched/un-patched files to backup dir
	if [ ! -d ${RVRT_TORCH_DIR} ]; then

		mkdir ${RVRT_TORCH_DIR}
		echo "THIS DIR CONTAINS UNTOUCHED/UNPATCHED FILES, DO NOT REMOVE! THIS DIR WILL GET REMOVED AUTOMATICALLY IF NECCESSARY" > ${RVRT_TORCH_DIR}/README
		mv ${TORCH_DIR}/FlashlightTile.java ${RVRT_TORCH_DIR}/
	
	fi

	# Moved patched files to CM source
	cp ${PATCHED_TORCH_DIR}/FlashlightTile.java ${TORCH_DIR}/

fi