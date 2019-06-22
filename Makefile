THEOS_DEVICE_IP = 192.168.2.104
INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS = armv7 armv7s arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = iOSREProject

iOSREProject_FILES = Tweak.x
iOSREProject_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"