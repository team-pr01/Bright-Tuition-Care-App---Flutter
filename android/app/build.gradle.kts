plugins {
    id("com.android.application")
    id("kotlin-android")
    // ✅ Firebase plugin
    id("com.google.gms.google-services")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.prtechsolutions.btc.btcclient"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.prtechsolutions.btc.btcclient"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// ✅ Firebase dependencies
dependencies {
    // ✅ Core library desugaring (for Java 8+ features)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
    
    // ✅ Google Play Services base
    implementation("com.google.android.gms:play-services-base:18.2.0")
    
    // ✅ Firebase BoM (Bill of Materials) - Manages Firebase versions
    implementation(platform("com.google.firebase:firebase-bom:32.5.0"))
    
    // ✅ Firebase Cloud Messaging
    implementation("com.google.firebase:firebase-messaging")
}