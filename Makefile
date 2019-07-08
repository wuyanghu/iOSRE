THEOS_DEVICE_IP = 127.0.0.1
THEOS_DEVICE_PORT = 2222
# THEOS_DEVICE_IP = 192.168.2.101
INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS = armv7 armv7s

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = iOSREProject

iOSREProject_FILES = src/*.m OCShowAlertView.m NSObject+LogWriteToFile.m Tweak_YouKu.xm Tweak_WeChat_Chat.xm Tweak.x Tweak_MobileNotes.x Tweak_SpringBoard.x Tweak_MobileMail.x Tweak_WeChat_Balance.xm
iOSREProject_CFLAGS = -fobjc-arc
iOSREProject_FRAMEWORKS = UIKit
include $(THEOS_MAKE_PATH)/tweak.mk
after-install::
	install.exec "killall -9 SpringBoard"