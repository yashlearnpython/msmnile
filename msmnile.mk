# Enable AVB 2.0
BOARD_AVB_ENABLE := true

# Enable chain partition for system, to facilitate system-only OTA in Treble.
BOARD_AVB_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_SYSTEM_ROLLBACK_INDEX := 0
BOARD_AVB_SYSTEM_ROLLBACK_INDEX_LOCATION := 1

TARGET_DEFINES_DALVIK_HEAP := true
$(call inherit-product, device/qcom/common/common64.mk)

#Inherit all except heap growth limit from phone-xhdpi-2048-dalvik-heap.mk
PRODUCT_PROPERTY_OVERRIDES  += \
	dalvik.vm.heapstartsize=8m \
	dalvik.vm.heapsize=512m \
	dalvik.vm.heaptargetutilization=0.75 \
	dalvik.vm.heapminfree=512k \
	dalvik.vm.heapmaxfree=8m


PRODUCT_NAME := msmnile
PRODUCT_DEVICE := msmnile
PRODUCT_BRAND := qti
PRODUCT_MODEL := msmnile for arm64

#Initial bringup flags
TARGET_USES_AOSP := false
TARGET_USES_AOSP_FOR_AUDIO := false
TARGET_USES_QCOM_BSP := false

# RRO configuration
TARGET_USES_RRO := true

#Default vendor image configuration
ifeq ($(ENABLE_VENDOR_IMAGE),)
ENABLE_VENDOR_IMAGE := false
endif
ifeq ($(ENABLE_VENDOR_IMAGE), true)
#Comment on msm8998 tree says that QTIC does not
# yet support system/vendor split. So disabling it
# for msmnile as well
#TARGET_USES_QTIC := false
#TARGET_USES_QTIC_EXTENSION := false

endif
TARGET_KERNEL_VERSION := 4.14

#Enable llvm support for kernel
KERNEL_LLVM_SUPPORT := true

#Enable sd-llvm suppport for kernel
KERNEL_SD_LLVM_SUPPORT := true

TARGET_USES_NQ_NFC := true
ifeq ($(TARGET_USES_NQ_NFC),true)
PRODUCT_COPY_FILES += \
    device/qcom/common/nfc/libnfc-brcm.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-nci.conf
endif

# default is nosdcard, S/W button enabled in resource
PRODUCT_CHARACTERISTICS := nosdcard

BOARD_FRP_PARTITION_NAME := frp

#Android EGL implementation
PRODUCT_PACKAGES += libGLES_android

-include $(QCPATH)/common/config/qtic-config.mk
-include hardware/qcom/display/config/msmnile.mk

# Video seccomp policy files
PRODUCT_COPY_FILES += \
    device/qcom/msmnile/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    device/qcom/msmnile/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy

PRODUCT_BOOT_JARS += tcmiface
PRODUCT_BOOT_JARS += telephony-ext
PRODUCT_PACKAGES += telephony-ext


TARGET_ENABLE_QC_AV_ENHANCEMENTS := true

TARGET_DISABLE_DASH := true
TARGET_DISABLE_QTI_VPP := false

ifneq ($(TARGET_DISABLE_DASH), true)
    PRODUCT_BOOT_JARS += qcmediaplayer
endif

ifneq ($(strip $(QCPATH)),)
    PRODUCT_BOOT_JARS += WfdCommon
endif

ifneq ($(strip $(QCPATH)),)
    PRODUCT_BOOT_JARS += libprotobuf-java_mls
endif

# Video codec configuration files
ifeq ($(TARGET_ENABLE_QC_AV_ENHANCEMENTS), true)
PRODUCT_COPY_FILES += device/qcom/msmnile/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_vendor.xml

PRODUCT_COPY_FILES += device/qcom/msmnile/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml
PRODUCT_COPY_FILES += device/qcom/msmnile/media_codecs_vendor.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_vendor.xml

PRODUCT_COPY_FILES += device/qcom/msmnile/media_codecs_vendor_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_vendor_audio.xml

PRODUCT_COPY_FILES += device/qcom/msmnile/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml
endif #TARGET_ENABLE_QC_AV_ENHANCEMENTS

PRODUCT_COPY_FILES += hardware/qcom/media/conf_files/msmnile/system_properties.xml:$(TARGET_COPY_OUT_VENDOR)/etc/system_properties.xml

PRODUCT_PACKAGES += android.hardware.media.omx@1.0-impl

# Audio configuration file
-include $(TOPDIR)hardware/qcom/audio/configs/msmnile/msmnile.mk

#Audio DLKM
AUDIO_DLKM := audio_apr.ko
AUDIO_DLKM += audio_wglink.ko
AUDIO_DLKM += audio_q6_pdr.ko
AUDIO_DLKM += audio_q6_notifier.ko
AUDIO_DLKM += audio_adsp_loader.ko
AUDIO_DLKM += audio_q6.ko
AUDIO_DLKM += audio_usf.ko
AUDIO_DLKM += audio_pinctrl_wcd.ko
AUDIO_DLKM += audio_swr.ko
AUDIO_DLKM += audio_wcd_core.ko
AUDIO_DLKM += audio_swr_ctrl.ko
AUDIO_DLKM += audio_wsa881x.ko
AUDIO_DLKM += audio_platform.ko
AUDIO_DLKM += audio_hdmi.ko
AUDIO_DLKM += audio_stub.ko
AUDIO_DLKM += audio_wcd9xxx.ko
AUDIO_DLKM += audio_mbhc.ko
AUDIO_DLKM += audio_wcd9360.ko
AUDIO_DLKM += audio_wcd_spi.ko
AUDIO_DLKM += audio_native.ko
AUDIO_DLKM += audio_machine_msmnile.ko
AUDIO_DLKM += audio_wcd934x.ko
PRODUCT_PACKAGES += $(AUDIO_DLKM)

PRODUCT_PACKAGES += fs_config_files

#A/B related packages
PRODUCT_PACKAGES += update_engine \
    update_engine_client \
    update_verifier \
    bootctrl.msmnile \
    brillo_update_payload \
    android.hardware.boot@1.0-impl \
    android.hardware.boot@1.0-service

#Boot control HAL test app
PRODUCT_PACKAGES_DEBUG += bootctl


#Healthd packages
PRODUCT_PACKAGES += \
    android.hardware.health@1.0-impl \
    android.hardware.health@1.0-convert \
    android.hardware.health@1.0-service \
    libhealthd.msm

# Fingerprint feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml \

DEVICE_MANIFEST_FILE := device/qcom/msmnile/manifest.xml
DEVICE_MATRIX_FILE   := device/qcom/common/compatibility_matrix.xml
DEVICE_FRAMEWORK_MANIFEST_FILE := device/qcom/msmnile/framework_manifest.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := device/qcom/msmnile/vendor_framework_compatibility_matrix.xml


#ANT+ stack
PRODUCT_PACKAGES += \
    AntHalService \
    libantradio \
    antradio_app \
    libvolumelistener

# Display/Graphics
PRODUCT_PACKAGES += \
    android.hardware.configstore@1.0-service \
    android.hardware.broadcastradio@1.0-impl

# FBE support
PRODUCT_COPY_FILES += \
    device/qcom/msmnile/init.qti.qseecomd.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qti.qseecomd.sh \
    device/qcom/msmnile/init.qti.getbootdevice.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qti.getbootdevice.sh

# Strongbox support
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.strongbox_keystore.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.strongbox_keystore.xml

# MSM IRQ Balancer configuration file
PRODUCT_COPY_FILES += device/qcom/msmnile/msm_irqbalance.conf:$(TARGET_COPY_OUT_VENDOR)/etc/msm_irqbalance.conf

# Powerhint configuration file
PRODUCT_COPY_FILES += device/qcom/msmnile/powerhint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.xml

# Camera configuration file. Shared by passthrough/binderized camera HAL
PRODUCT_PACKAGES += camera.device@3.2-impl
PRODUCT_PACKAGES += camera.device@1.0-impl
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-impl
# Enable binderized camera HAL
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-service_64

# Vibrator
PRODUCT_PACKAGES += \
    vendor.qti.hardware.vibrator@1.2-service

# Context hub HAL
PRODUCT_PACKAGES += \
    android.hardware.contexthub@1.0-impl.generic \
    android.hardware.contexthub@1.0-service

# system prop for Bluetooth SOC type
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.qcom.bluetooth.soc=cherokee

# system prop for enabling QFS (QTI Fingerprint Solution)
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.qfp=true

# MIDI feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

# USB default HAL
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service

#PASR HAL and APP
PRODUCT_PACKAGES += \
    vendor.qti.power.pasrmanager@1.0-service \
    vendor.qti.power.pasrmanager@1.0-impl \
    pasrservice
#Property to enable/disable PASR
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.power.pasr.enabled=true

# Sensor conf files
PRODUCT_COPY_FILES += \
    device/qcom/msmnile/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.sensor.ambient_temperature.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.ambient_temperature.xml \
    frameworks/native/data/etc/android.hardware.sensor.relative_humidity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.relative_humidity.xml \
    frameworks/native/data/etc/android.hardware.sensor.hifi_sensors.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.hifi_sensors.xml


# Kernel modules install path
KERNEL_MODULES_INSTALL := dlkm
KERNEL_MODULES_OUT := out/target/product/$(PRODUCT_NAME)/$(KERNEL_MODULES_INSTALL)/lib/modules

#FEATURE_OPENGLES_EXTENSION_PACK support string config file
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml

# system prop for opengles version
#
# 196608 is decimal for 0x30000 to report version 3
# 196609 is decimal for 0x30001 to report version 3.1
# 196610 is decimal for 0x30002 to report version 3.2
PRODUCT_PROPERTY_OVERRIDES  += \
    ro.opengles.version=196610

#Exclude vibrator from InputManager
PRODUCT_COPY_FILES += \
    device/qcom/msmnile/excluded-input-devices.xml:system/etc/excluded-input-devices.xml

#Enable full treble flag
PRODUCT_FULL_TREBLE_OVERRIDE := true
PRODUCT_VENDOR_MOVE_ENABLED := true
PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE := true

KMGK_USE_QTI_SERVICE := true

#Enable KEYMASTER 4.0
ENABLE_KM_4_0 := true
#Should be enabled only on msmnile
ENABLE_STRONGBOX_KM := true

ifneq ($(strip $(TARGET_USES_RRO)),true)
DEVICE_PACKAGE_OVERLAYS += device/qcom/msmnile/overlay
endif


ENABLE_VENDOR_RIL_SERVICE := true
#Enable vndk-sp Libraries
PRODUCT_PACKAGES += vndk_package

PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE:=true

#----------------------------------------------------------------------
# wlan specific
#----------------------------------------------------------------------
include device/qcom/wlan/msmnile/wlan.mk

TARGET_MOUNT_POINTS_SYMLINKS := false

# propery "ro.vendor.build.security_patch" is checked for
# # CTS compliance so need to make sure its set with following
# # format "YYYY-MM-DD" on production devices.
# #
ifeq ($(ENABLE_VENDOR_IMAGE), true)
 VENDOR_SECURITY_PATCH := 2018-06-05
endif

#Property to enable/disable scroll pre-obtain view
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.scroll.preobtain.enable := false

TARGET_USES_MKE2FS := true

PRODUCT_PROPERTY_OVERRIDES += \
ro.crypto.volume.filenames_mode = "aes-256-cts" \
ro.crypto.allow_encrypt_override = true

$(call inherit-product, build/make/target/product/product_launched_with_p.mk)

#Thermal
PRODUCT_PACKAGES += android.hardware.thermal@1.0-impl \
                    android.hardware.thermal@1.0-service
