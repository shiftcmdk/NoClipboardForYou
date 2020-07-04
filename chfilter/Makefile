TARGET := iphone:clang:latest:11.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TOOL_NAME = chfilter
chfilter_CODESIGN_FLAGS = -Sent.xml

chfilter_FILES = main.m
chfilter_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tool.mk
