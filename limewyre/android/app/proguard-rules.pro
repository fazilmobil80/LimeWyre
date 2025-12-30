# ==============================
# javax.annotation (compile-time only)
# ==============================
-keep class javax.annotation.** { *; }
-keep class javax.annotation.concurrent.** { *; }

# ==============================
# TINK (required for Firebase)
# ==============================
-keep class com.google.crypto.tink.** { *; }

# ==============================
# Disable unused Tink HTTP downloader
# ==============================
-assumenosideeffects class com.google.crypto.tink.util.KeysDownloader {
    *;
}

-dontwarn com.google.api.client.**
-dontwarn org.joda.time.**
