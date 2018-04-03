# Consumer IR
TARGET_PROVIDES_CONSUMERIR_HAL := true

PRODUCT_PACKAGES += \
    consumerir.msm8992

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.consumerir.xml:system/etc/permissions/android.hardware.consumerir.xml
