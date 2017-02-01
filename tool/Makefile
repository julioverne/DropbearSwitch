include theos/makefiles/common.mk

TOOL_NAME = toggleDropBearSwitch
toggleDropBearSwitch_FILES = main.mm

toggleDropBearSwitch_FRAMEWORKS = UIKit
toggleDropBearSwitch_ARCHS = armv7 arm64
export ARCHS = armv7 arm64
toggleDropBearSwitch_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tool.mk

all::
	@echo "[+] Copying Files..."
	@cp ./obj/obj/debug/toggleDropBearSwitch //usr/bin/toggleDropBearSwitch
	@ldid -S //usr/bin/toggleDropBearSwitch
	@chown root:wheel //usr/bin/toggleDropBearSwitch
	@chmod 6755 //usr/bin/toggleDropBearSwitch
	@echo "DONE"
	

