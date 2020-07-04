TARGET := iphone:clang:latest:11.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = NoClipboardForYouPreferences

NoClipboardForYouPreferences_FILES = NCFYRootListController.xm NCFYApp.m NCFYAppCell.m
NoClipboardForYouPreferences_INSTALL_PATH = /Library/PreferenceBundles
NoClipboardForYouPreferences_FRAMEWORKS = UIKit
NoClipboardForYouPreferences_PRIVATE_FRAMEWORKS = Preferences
NoClipboardForYouPreferences_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/NoClipboardForYouPreferences.plist$(ECHO_END)
