# THEOS_DEVICE_IP = 127.0.0.1
# THEOS_DEVICE_PORT = 2222

THEOS_DEVICE_IP = 192.168.1.101


# INSTALL_TARGET_PROCESSES = Youkui4Phone WeChat
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = iOSREProject

iOSREProject_FILES = src/*.m OCShowAlertView.m OCLogWriteToFile.m NSObject+AllIvarLog.m NSObject+SimplePropertyLog.m Tweak_YouKu.xm Tweak_WeChat_Chat.xm Tweak.x Tweak_MobileNotes.x Tweak_SpringBoard.x Tweak_MobileMail.x Tweak_WeChat_Balance.xm Tweak_VirtualLocation.xm Tweak_WeChat_Step.xm Tweak_UserAgent.xm
iOSREProject_CFLAGS = -fobjc-arc
iOSREProject_FRAMEWORKS = UIKit
include $(THEOS_MAKE_PATH)/tweak.mk
after-install::
	install.exec "killall -9 WeChat"