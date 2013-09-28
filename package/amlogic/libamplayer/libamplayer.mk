#############################################################
#
# libamplayer
#
#############################################################
ifeq ($(BR2_BOARD_TYPE_AMLOGIC_M6),y)
LIBAMPLAYER_VERSION:=m6
FIRMWARE_DIR = firmware-m6
endif
ifeq ($(BR2_BOARD_TYPE_AMLOGIC_M3),y)
LIBAMPLAYER_VERSION:=m3
FIRMWARE_DIR = firmware
endif
ifeq ($(BR2_BOARD_TYPE_AMLOGIC_M1),y)
LIBAMPLAYER_VERSION:=m1
FIRMWARE_DIR = firmware
endif

LIBAMPLAYER_SITE=$(TOPDIR)/package/amlogic/libamplayer/src-$(LIBAMPLAYER_VERSION)
LIBAMPLAYER_SITE_METHOD=local
LIBAMPLAYER_INSTALL_STAGING=YES
LIBAMPLAYER_INSTALL_TARGET=YES

ifeq ($(BR2_PACKAGE_LIBAMPLAYER),y)
# actually required for amavutils and amffmpeg
LIBAMPLAYER_DEPENDENCIES += alsa-lib librtmp pkg-config
AMFFMPEG_DIR = $(BUILD_DIR)/libamplayer-$(LIBAMPLAYER_VERSION)/amffmpeg
AMAVUTILS_DIR = $(BUILD_DIR)/libamplayer-$(LIBAMPLAYER_VERSION)/amavutils
AMFFMPEG_EXTRA_LDFLAGS += --extra-ldflags="-lamavutils"
endif

LIBAMPLAYER_BUILD_CMDS =
 
ifneq ($(BR2_BOARD_TYPE_AMLOGIC_M1),y)
LIBAMPLAYER_BUILD_CMDS += \
    mkdir -p $(AMAVUTILS_DIR) && \
    $(call AMAVUTILS_INSTALL_STAGING_CMDS) &&
endif

LIBAMPLAYER_BUILD_CMDS += \
    mkdir -p $(AMFFMPEG_DIR) && \
    $(call AMFFMPEG_CONFIGURE_CMDS) && \
    $(call AMFFMPEG_BUILD_CMDS) && \
    $(call AMFFMPEG_INSTALL_STAGING_CMDS)

LIBAMPLAYER_INSTALL_STAGING_CMDS = \
	mkdir -p $(STAGING_DIR)/usr/include && \
	chmod 755 $(@D)/usr/include/*.h && \
	chmod 755 $(@D)/usr/include/amlplayer/*.h && \
	chmod 755 $(@D)/usr/include/amlplayer/amports/*.h && \
	chmod 755 $(@D)/usr/include/amlplayer/ppmgr/*.h && \
	chmod 755 $(@D)/usr/lib/*.bin && \
	chmod 755 $(@D)/usr/lib/*.so* && \
	cp -ff $(@D)/usr/include/*.h $(STAGING_DIR)/usr/include && \
	mkdir -p $(STAGING_DIR)/usr/include/amlplayer && \
	cp -ff $(@D)/usr/include/amlplayer/*.h $(STAGING_DIR)/usr/include/amlplayer && \
	mkdir -p $(STAGING_DIR)/usr/include/amlplayer/amports && \
	cp -rf $(@D)/usr/include/amlplayer/amports/*.h $(STAGING_DIR)/usr/include/amlplayer/amports && \
	mkdir -p $(STAGING_DIR)/usr/include/amlplayer/ppmgr && \
	cp -rf $(@D)/usr/include/amlplayer/ppmgr/*.h $(STAGING_DIR)/usr/include/amlplayer/ppmgr && \
	mkdir -p $(STAGING_DIR)/usr/lib && \
	cp -rf $(@D)/usr/lib/*.so* $(STAGING_DIR)/usr/lib && \
	cp -rf $(@D)/usr/lib/*.bin $(STAGING_DIR)/usr/lib && \
	mv -f $(STAGING_DIR)/usr/lib/libamadec.bin $(STAGING_DIR)/usr/lib/libamadec.so && \
	mv -f $(STAGING_DIR)/usr/lib/libamplayer.bin $(STAGING_DIR)/usr/lib/libamplayer.so && \
	ln -s $(STAGING_DIR)/usr/lib/libamcodec.so.0.0 $(STAGING_DIR)/usr/lib/libamcodec.so

# We do have aditional library for M1
ifeq ($(BR2_BOARD_TYPE_AMLOGIC_M1),y)

LIBAMPLAYER_INSTALL_STAGING_CMDS += && mv $(STAGING_DIR)/usr/lib/libamcontroler.bin $(STAGING_DIR)/usr/lib/libamcontroler.so

endif

LIBAMPLAYER_INSTALL_STAGING_CMDS += && cp -rf $(@D)/usr/include/amlplayer/* $(STAGING_DIR)/usr/include


LIBAMPLAYER_INSTALL_TARGET_CMDS =

ifneq ($(BR2_BOARD_TYPE_AMLOGIC_M1),y)
LIBAMPLAYER_INSTALL_TARGET_CMDS += \
    $(call AMAVUTILS_INSTALL_TARGET_CMDS) && 
endif

LIBAMPLAYER_INSTALL_TARGET_CMDS += \
	$(call AMFFMPEG_INSTALL_TARGET_CMDS) && \
	mkdir -p $(TARGET_DIR)/lib/firmware && \
	cp -rf $(@D)/lib/$(FIRMWARE_DIR)/*.bin $(TARGET_DIR)/lib/firmware && \
	chmod -R 755 $(TARGET_DIR)/lib/firmware/* && \
	mkdir -p $(TARGET_DIR)/usr/lib && \
	cp -rf $(@D)/usr/lib/*.so* $(TARGET_DIR)/usr/lib && \
	chmod -R 755 $(TARGET_DIR)/usr/lib/* && \
	ln -s $(TARGET_DIR)/usr/lib/libamcodec.so.0.0 $(TARGET_DIR)/usr/lib/libamcodec.so


$(eval $(call generic-package))
