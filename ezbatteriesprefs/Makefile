ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = EZBatteriesPrefs
EZBatteriesPrefs_FILES = EZBRootListController.m
EZBatteriesPrefs_INSTALL_PATH = /Library/PreferenceBundles
EZBatteriesPrefs_FRAMEWORKS = UIKit
EZBatteriesPrefs_EXTRA_FRAMEWORKS += CepheiPrefs
EZBatteriesPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/EZBatteriesPrefs.plist$(ECHO_END)
