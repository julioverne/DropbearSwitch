include theos/makefiles/common.mk

BUNDLE_NAME = DropBearSwitch
DropBearSwitch_FILES = Switch.x
DropBearSwitch_FRAMEWORKS = UIKit
DropBearSwitch_LIBRARIES = flipswitch
DropBearSwitch_CFLAGS = -fobjc-arc
DropBearSwitch_LDFLAGS = -Wl,-segalign,4000
DropBearSwitch_INSTALL_PATH = /Library/Switches
DropBearSwitch_ARCHS = armv7 arm64
export ARCHS = armv7 arm64

include $(THEOS_MAKE_PATH)/bundle.mk

all::
	@echo "[+] Copying Files..."
	@cp -rf ./debug/DropBearSwitch.bundle/DropBearSwitch //Library/Switches/DropBearSwitch.bundle/DropBearSwitch
	@/usr/bin/ldid -S //Library/Switches/DropBearSwitch.bundle/DropBearSwitch
	@echo "DONE"
	