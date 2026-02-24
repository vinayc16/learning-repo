# Keep Google ML Kit Text Recognition classes
-keep class com.google.mlkit.vision.text.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_text_common.** { *; }

# Keep all ML Kit Chinese text recognition classes
-keep class com.google.mlkit.vision.text.chinese.** { *; }
-dontwarn com.google.mlkit.vision.text.chinese.**

# Keep all ML Kit Devanagari text recognition classes
-keep class com.google.mlkit.vision.text.devanagari.** { *; }
-dontwarn com.google.mlkit.vision.text.devanagari.**

# Keep all ML Kit Japanese text recognition classes
-keep class com.google.mlkit.vision.text.japanese.** { *; }
-dontwarn com.google.mlkit.vision.text.japanese.**

# Keep all ML Kit Korean text recognition classes
-keep class com.google.mlkit.vision.text.korean.** { *; }
-dontwarn com.google.mlkit.vision.text.korean.**

# Keep all ML Kit Latin text recognition classes
-keep class com.google.mlkit.vision.text.latin.** { *; }
-dontwarn com.google.mlkit.vision.text.latin.**

# Keep Google ML Kit common classes
-keep class com.google.mlkit.common.** { *; }
-dontwarn com.google.mlkit.common.**

# Keep annotations
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelables
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}
