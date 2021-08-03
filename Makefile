TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e
PACKAGE_VERSION = 1.0.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = RWPSlider

$(TWEAK_NAME)_FILES = Tweak.x
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS = MediaAccessibility
$(TWEAK_NAME)_LIBRARIES = Accessibility

include $(THEOS_MAKE_PATH)/tweak.mk
