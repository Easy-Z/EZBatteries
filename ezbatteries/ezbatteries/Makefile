include $(THEOS)/makefiles/common.mk

TWEAK_NAME = EZBatteries
EZBatteries_FILES = Tweak.xm
EZBatteries_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	mkdir -p "$(THEOS_STAGING_DIR)/Library/EZBatteries"
	cp Resources/* "$(THEOS_STAGING_DIR)/Library/EZBatteries"

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += ezbatteriesprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
