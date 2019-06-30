THEOS_DEVICE_IP = 127.0.0.1
THEOS_DEVICE_PORT = 2222
INSTALL_TARGET_PROCESSES = SpringBoard CMRead WeXin MobileNotes
ARCHS = armv7 armv7s arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = iOSREProject

iOSREProject_FILES = Tweak.x Tweak_MobileNotes.x Tweak_SpringBoard.x Tweak_MobileMail.x
iOSREProject_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 CMRead"