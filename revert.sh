#!/bin/bash

LOCAL_PATH=$(dirname $(readlink -f $0))
TOP=$LOCAL_PATH/../../../..

TORCH_DIR=${TOP}/frameworks/base/packages/SystemUI/src/com/android/systemui/qs/tiles
RVRT_TORCH_DIR=${TORCH_DIR}/.backup

VOLD_DIR=${TOP}/system/vold
RVRT_VOLD_DIR=${VOLD_DIR}/.backup

PATCHED_VOLD_DIR=${LOCAL_PATH}/patched/system/vold
PATCHED_TORCH_DIR=${LOCAL_PATH}/patched/frameworks/base/packages/SystemUI/src/com/android/systemui/qs/tiles

if [ -f ${LOCAL_PATH}/PATCHED ]; then
 
	echo "Not building kitakami! Reverting kitakami patches!"
   
	echo 0 > ${LOCAL_PATH}/PATCHED
   
   if [ -f ${VOLD_DIR}/.patchlist ]; then

   		if (grep -Fq "Utils.cpp" ${VOLD_DIR}/.patchlist); then

   			if [ $(cat ${VOLD_DIR}/.patch-device) = "kitakami" ]; then
   			
   				# Revert original files
				mv ${RVRT_VOLD_DIR}/Utils.cpp ${VOLD_DIR}/
			
			fi
		fi

		if (grep -Fq "Android.mk" ${VOLD_DIR}/.patchlist); then

			if [ $(cat ${VOLD_DIR}/.patch-device) = "kitakami" ]; then

				mv ${RVRT_VOLD_DIR}/Android.mk ${VOLD_DIR}/

				rm -R ${RVRT_VOLD_DIR}

				rm ${VOLD_DIR}/.patchlist
				rm ${VOLD_DIR}/.patch-device

			fi
		fi
	fi

	if [ -f ${TORCH_DIR}/.patchlist ]; then
		if (grep -Fq "FlashlightTile.java" ${TORCH_DIR}/.patchlist); then
   			if [ $(cat ${TORCH_DIR}/.patch-device) = "kitakami" ]; then

   				# Revert original files
				mv ${RVRT_TORCH_DIR}/FlashlightTile.java ${TORCH_DIR}/
				rm -R ${RVRT_TORCH_DIR}

				rm ${TORCH_DIR}/.patchlist
				rm ${TORCH_DIR}/.patch-device

			fi
		fi
	fi
fi
