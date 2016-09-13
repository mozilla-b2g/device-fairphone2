TARGET_USES_QCOM_BSP := true
TARGET_USES_QCA_NFC := other

ifeq ($(TARGET_USES_QCOM_BSP), true)
# Add QC Video Enhancements flag
TARGET_ENABLE_QC_AV_ENHANCEMENTS := true
endif #TARGET_USES_QCOM_BSP

#TARGET_DISABLE_DASH := true
#TARGET_DISABLE_OMX_SECURE_TEST_APP := true

# CAF Bluetooth API is different from AOSP, so we need this flag to tell de build system
# that we want to use the CAF headers to build the Bluetoothd daemon
BOARD_BLUETOOTH_BDROID_USE_CAF_EXTENSIONS := true

TARGET_DEVICE_BLOBS_LIST := true
TARGET_DEVICE_BLOBS_SRC_DIR := out/target/product/FP2/system/
TARGET_DEVICE_BLOBS := device/fairphone_devices/FP2/proprietary-files.txt

# media_profiles and media_codecs xmls for 8974
ifeq ($(TARGET_ENABLE_QC_AV_ENHANCEMENTS), true)
PRODUCT_COPY_FILES += device/fairphone_devices/FP2/media/media_profiles_8974.xml:system/etc/media_profiles.xml \
                      device/fairphone_devices/FP2/media/media_codecs_8974.xml:system/etc/media_codecs.xml
endif  #TARGET_ENABLE_QC_AV_ENHANCEMENTS

ifeq ($(PROPRIETARY_BLOBS_EXIST),true)
PRODUCT_COPY_FILES += \
    device/fairphone_devices/FP2/apns-conf.xml:system/etc/apns-conf.xml
endif

$(call inherit-product, device/qcom/common/common.mk)

PRODUCT_NAME := FP2
PRODUCT_DEVICE := FP2
PRODUCT_BRAND := Fairphone
PRODUCT_MANUFACTURER := Fairphone
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-fairphone

GAIA_DEV_PIXELS_PER_PX := 3

# Audio configuration file
PRODUCT_COPY_FILES += \
    device/fairphone_devices/FP2/audio_policy.conf:system/etc/audio_policy.conf \
    device/fairphone_devices/FP2/audio_effects.conf:system/vendor/etc/audio_effects.conf \
    device/fairphone_devices/FP2/mixer_paths.xml:system/etc/mixer_paths.xml \
    device/fairphone_devices/FP2/mixer_paths_auxpcm.xml:system/etc/mixer_paths_auxpcm.xml

# Display logo image file
PRODUCT_COPY_FILES += \
    device/fairphone_devices/FP2/splash.img:$(PRODUCT_OUT)/splash.img

PRODUCT_PACKAGES += \
    libqcomvisualizer \
    libqcomvoiceprocessing \
    libqcompostprocbundle

# Feature definition files for 8974
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:system/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:system/etc/permissions/android.hardware.sensor.stepdetector.xml

#battery_monitor
#PRODUCT_PACKAGES += \
#    battery_monitor \
#    battery_shutdown

#fstab.qcom
PRODUCT_PACKAGES += fstab.qcom

#wlan driver
PRODUCT_COPY_FILES += \
    device/fairphone_devices/FP2/WCNSS_qcom_cfg.ini:system/etc/wifi/WCNSS_qcom_cfg.ini \
    device/fairphone_devices/FP2/WCNSS_qcom_wlan_nv.bin:persist/WCNSS_qcom_wlan_nv.bin

PRODUCT_PACKAGES += \
    wpa_supplicant_overlay.conf \
    p2p_supplicant_overlay.conf

PRODUCT_PACKAGES += wcnss_service

# for Gecko to support bluedroid stack
PRODUCT_PACKAGES += \
    bluetooth.default

#ANT stack
#PRODUCT_PACKAGES += \
#        AntHalService \
#        libantradio \
#        ANTRadioService \
#        antradio_app

# Enable strict operation
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.strict_op_enable=false \
    persist.sys.usb.config=mtp

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.whitelist=/system/etc/whitelist_appops.xml

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    camera2.portability.force_api=1

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.adb.secure=0 

PRODUCT_COPY_FILES += \
    device/fairphone_devices/FP2/whitelist_appops.xml:system/etc/whitelist_appops.xml


# NFC packages
ifeq ($(TARGET_USES_QCA_NFC),true)
NFC_D := true

ifeq ($(NFC_D), true)
#    PRODUCT_PACKAGES += \
        libnfcD-nci \
        libnfcD_nci_jni \
        nfc_nci.msm8974 \
        NfcDNci \
        Tag \
        com.android.nfc_extras \
        com.android.nfc.helper
 PRODUCT_PACKAGES += \
        libnfcD-nci \
        nfc_nci.msm8974 \
        NfcDNci
else
# PRODUCT_PACKAGES += \
    libnfc-nci \
    libnfc_nci_jni \
    nfc_nci.msm8974 \
    NfcNci \
    Tag \
    com.android.nfc_extras
 PRODUCT_PACKAGES += \
    libnfc-nci \
    nfc_nci.msm8974 \
    NfcNci 
endif

# file that declares the MIFARE NFC constant
# Commands to migrate prefs from com.android.nfc3 to com.android.nfc
# NFC access control + feature files + configuration
PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/com.nxp.mifare.xml:system/etc/permissions/com.nxp.mifare.xml \
        frameworks/native/data/etc/com.android.nfc_extras.xml:system/etc/permissions/com.android.nfc_extras.xml \
        frameworks/native/data/etc/android.hardware.nfc.xml:system/etc/permissions/android.hardware.nfc.xml
# Enable NFC Forum testing by temporarily changing the PRODUCT_BOOT_JARS
# line has to be in sync with build/target/product/core_base.mk
endif

#PRODUCT_BOOT_JARS += qcmediaplayer \
                     org.codeaurora.Performance \
                     vcard \
                     tcmiface
ifneq ($(strip $(QCPATH)),)
#PRODUCT_BOOT_JARS += WfdCommon
#PRODUCT_BOOT_JARS += qcom.fmradio
#PRODUCT_BOOT_JARS += security-bridge
#PRODUCT_BOOT_JARS += qsb-port
#PRODUCT_BOOT_JARS += oem-services
endif

# PRODUCT_PACKAGES += \
                    FairphoneUpdater \
                    FairphoneLauncher3 \
                    AppOps \
                    MyContactsWidget \
                    ClockWidget \
                    FairphonePrivacyImpact \
                    ProgrammableButton

#PRODUCT_PACKAGES += iFixit

# Amaze File Manager
#PRODUCT_PACKAGES += Amaze 

# Add boot animation
PRODUCT_COPY_FILES += device/fairphone_devices/FP2/bootanimation.zip:system/media/bootanimation.zip

# Set default ringtone to Fairphone's
PRODUCT_COPY_FILES += device/fairphone_devices/FP2/Sunbeam.mp3:system/media/audio/ringtones/Fairphone.mp3

PRODUCT_PROPERTY_OVERRIDES += \
                              fairphone.ota.device=$(PRODUCT_DEVICE) \
                              fairphone.ota.time=`date` \
                              fairphone.ota.android_version=$(PLATFORM_VERSION) \
                              fairphone.ota.build_number=1.0 \
                              fairphone.ota.version.number=1 \
                              fairphone.ota.version.name=Onion \
                              fairphone.ota.beta=0 \
                              fairphone.ota.image_type=FP2

PRODUCT_MODEL := FP2

# include an expanded selection of fonts for the SDK.
EXTENDED_FONT_FOOTPRINT := true

# Preferred Applications for Fairphone
PRODUCT_COPY_FILES += \
    device/fairphone_devices/FP2/preferred.xml:system/etc/preferred-apps/fp.xml

# remove /dev/diag in user version for CTS
ifeq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_COPY_FILES += device/qcom/common/rootdir/etc/init.qcom.diag.rc.user:root/init.qcom.diag.rc
endif

# ifeq ($(strip $(FP2_SKIP_BOOT_JARS_CHECK)),)
# SKIP_BOOT_JARS_CHECK := false
# endif

# Enable/disable some FFOS features
PRODUCT_PROPERTY_OVERRIDES += \
    ro.moz.has_home_button=0 \
    ro.moz.nfc.enabled=false \
    ro.moz.ril.0.network_types=gsm,wcdma,lte \
    ro.moz.ril.1.network_types=gsm,wcdma,lte \
    ro.moz.ril.emergency_by_default=true \
    ro.moz.ril.subscription_control=true \
    ro.moz.ril.numclients=2


# Gecko (Gonk layer) needs this file for VolumeManager to work
PRODUCT_COPY_FILES += \
    device/fairphone_devices/FP2/volume.cfg:system/etc/volume.cfg


DEVICE_PACKAGE_OVERLAYS += device/fairphone_devices/FP2/overlay

# Build Gecko with gcc-4.9
GECKO_TOOLS_PREFIX = prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-
