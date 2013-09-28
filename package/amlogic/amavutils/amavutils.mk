#############################################################
#
# amavutils
#
#############################################################
define AMAVUTILS_BUILD_CMDS
  $(MAKE) CC="$(TARGET_CC)" -C $(AMAVUTILS_DIR)
endef

define AMAVUTILS_INSTALL_STAGING_CMDS
  mv -f $(AMAVUTILS_DIR)/libamavutils.bin $(AMAVUTILS_DIR)/libamavutils.so
  chmod +x $(AMAVUTILS_DIR)/libamavutils.so
  chmod 755 $(AMAVUTILS_DIR)/libamavutils.so
  cp -rf $(AMAVUTILS_DIR)/libamavutils.so $(STAGING_DIR)/lib
  cp -rf $(AMAVUTILS_DIR)/include/*.h $(STAGING_DIR)/usr/include/
endef

define AMAVUTILS_INSTALL_TARGET_CMDS
  cp -rf $(AMAVUTILS_DIR)/libamavutils.so $(TARGET_DIR)/lib
  chmod 755 $(TARGET_DIR)/lib/libamavutils.so
endef