ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = EzBatteries
EzBatteries_FILES = Tweak.xm
EZBatteries_LIBRARIES = activator

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
