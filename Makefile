INSTALL_TARGET_PROCESSES = SpringBoard

TARGET := iphone:clang:latest:11.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NoClipboardForYou

NoClipboardForYou_FILES = Tweak.x
NoClipboardForYou_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += noclipboardforyoupreferences
SUBPROJECTS += chfilter
include $(THEOS_MAKE_PATH)/aggregate.mk
