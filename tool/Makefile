include theos/makefiles/common.mk

TOOL_NAME = toogleDropBearSwitch
toogleDropBearSwitch_FILES = main.mm

toogleDropBearSwitch_FRAMEWORKS = UIKit
toogleDropBearSwitch_ARCHS = armv7 arm64
export ARCHS = armv7 arm64
toogleDropBearSwitch_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tool.mk

all::
	@echo "[+] Copying Files..."
	@cp ./debug/toogleDropBearSwitch //usr/bin/toogleDropBearSwitch
	@ldid -S //usr/bin/toogleDropBearSwitch
	@chown 0:0 //usr/bin/toogleDropBearSwitch
	@chmod 6755 //usr/bin/toogleDropBearSwitch
	@echo "DONE"
	

