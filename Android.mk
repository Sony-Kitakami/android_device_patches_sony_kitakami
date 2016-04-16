LOCAL_PATH := device/patch/sony/kitakami

VOLD_DIR := $(LOCAL_PATH)/patched/system/vold
TORCH_DIR := $(LOCAL_PATH)/patched/frameworks/base/packages/SystemUI/src/com/android/systemui/qs/tiles

ifeq ($(SOMC_PLATFORM), kitakami)

	ifneq ($(wildcard $(LOCAL_PATH)/PATCHED.1),)

		$(shell touch $(LOCAL_PATH)/PATCHED.1)

		$(shell echo "Applying Vold patch")

		$(shell rm $(VOLD_DIR)/Utils.cpp)
		$(shell rm $(VOLD_DIR)/Android.mk)

		$(shell cp $(LOCAL_PATH)/patched/$(VOLD_DIR)/Utils.cpp $(VOLD_DIR)/)
		$(shell cp $(LOCAL_PATH)/patched/$(VOLD_DIR)/Android.mk $(VOLD_DIR)/)

		$(shell echo "Applying torch patch" )

		$(shell rm $(TORCH_DIR)/FlashlightTile.java)

		$(shell cp $(LOCAL_PATH)/patched/$(TORCH_DIR)/FlashlightTile.java $(TORCH_DIR)/)

	endif

else ifeq ($(wildcard $(LOCAL_PATH)/PATCHED.1)

	$(shell mv $(LOCAL_PATH)/PATCHED.1 $(LOCAL_PATH)/PATCHED.0)

endif

ifeq ($(wildcard $(LOCAL_PATH)/PATCHED.0)
 
	$(shell echo "Not building kitakami! Reverting kitakami patches!")
   
	$(shell rm $(LOCAL_PATH)/PATCHED.0)
   
	$(shell echo "Reverting vold patches")
   
	$(shell rm $(VOLD_DIR)/Utils.cpp)
	$(shell rm $(VOLD_DIR)/Android.mk)

	$(shell echo "Reverting Flashlight patches")

	$(shell rm $(TORCH_DIR)/FlashlightTile.java)

	$(shell echo "Fetching unpatched versions")

	$(shell repo sync --force-sync)

	$(shell echo "Patches reverted!")

endif
