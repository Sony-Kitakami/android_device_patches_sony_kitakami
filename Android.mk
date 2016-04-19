LOCAL_PATH := device/patches/sony/kitakami

ifeq ($(SOMC_PLATFORM), kitakami)
$(warning Kitakami device found, starting patcher!)
$(info $(shell ($(LOCAL_PATH)/patch.sh)))
$(warning Syncing patches)
$(info $(shell ($(LOCAL_PATH)/sync.sh)))
else
$(info $(shell ($(LOCAL_PATH)/revert.sh)))
endif