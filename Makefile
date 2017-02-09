include theos/makefiles/common.mk

SUBPROJECTS += switch
SUBPROJECTS += tool

include $(THEOS_MAKE_PATH)/aggregate.mk

all::
	@echo "DONE."
	