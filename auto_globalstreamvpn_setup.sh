#!/bin/bash
# ======================================
# AUTO FINAL SETUP: GlobalStreamVPN Android + Gradle + GitHub Actions + Push GitHub
# ======================================

echo "======================================"
echo "AUTO FINAL SETUP: GlobalStreamVPN"
echo "======================================"

# =============================
# Configurar Termux
# =============================
pkg update -y && pkg upgrade -y
pkg install -y git wget unzip openjdk-17 coreutils findutils nano

PROJECT_DIR="$HOME/GlobalStreamVPN"
APP_DIR="$PROJECT_DIR/app"

mkdir -p "$APP_DIR/src/main/java/com/globalstreamvpn"
mkdir -p "$APP_DIR/src/main/res/layout"

# =============================
# gradle.properties
# =============================
cat > "$PROJECT_DIR/gradle.properties" << EOF
android.useAndroidX=true
android.enableJetifier=true
android.suppressUnsupportedCompileSdk=34
EOF

# =============================
# build.gradle (app)
# =============================
cat > "$APP_DIR/build.gradle" << EOF
plugins {
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'
}

android {
    namespace 'com.globalstreamvpn'
    compileSdk 34

    defaultConfig {
        applicationId "com.globalstreamvpn"
        minSdk 21
        targetSdk 34
        versionCode 1
        versionName "1.0"
    }

    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}

dependencies {
    implementation "androidx.core:core-ktx:1.13.0"
    implementation "androidx.appcompat:appcompat:1.7.0"
    implementation "com.google.android.material:material:1.11.0"
}
EOF

# =============================
# AndroidManifest.xml
# =============================
cat > "$APP_DIR/src/main/AndroidManifest.xml" << EOF
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <application
        android:label="GlobalStreamVPN"
        android:icon="@mipmap/ic_launcher">
        
        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>
</manifest>
EOF

# =============================
# MainActivity.kt
# =============================
cat > "$APP_DIR/src/main/java/com/globalstreamvpn/MainActivity.kt" << EOF
package com.globalstreamvpn

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }
}
EOF

# =============================
# layout XML
# =============================
cat > "$APP_DIR/src/main/res/layout/activity_main.xml" << EOF
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:padding="16dp">

    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="GlobalStreamVPN" />

</LinearLayout>
EOF

# =============================
# build.gradle raiz e settings.gradle
# =============================
cat > "$PROJECT_DIR/build.gradle" << EOF
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath "com.android.tools.build:gradle:8.1.0"
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.0"
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
EOF

cat > "$PROJECT_DIR/settings.gradle" << EOF
rootProject.name = "GlobalStreamVPN"
include ':app'
EOF

# =============================
# README.md
# =============================
cat > "$PROJECT_DIR/README.md" << EOF
# GlobalStreamVPN

Projeto Android VPN pronto para build via GitHub Actions.
EOF

# =============================
# GitHub Actions workflow
# =============================
mkdir -p "$PROJECT_DIR/.github/workflows"
cat > "$PROJECT_DIR/.github/workflows/build_apk.yml" << EOF
name: Build APK

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup JDK 17
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'
      - name: Build Debug APK
        run: ./gradlew assembleDebug
      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: GlobalStreamVPN-APK
          path: app/build/outputs/apk/debug/app-debug.apk
EOF

# =============================
# Gradle Wrapper
# =============================
cd "$PROJECT_DIR" || exit
gradle wrapper --gradle-version 8.3

# =============================
# Inicializar Git e push
# =============================
git init
git add .
git commit -m "Setup completo: Android VPN + Gradle Wrapper + GitHub Actions + android:exported + namespace"
git branch -M main
git remote add origin https://github.com/wallaceleandro/GlobalStreamVPN.git
git push -u origin main --force

echo "======================================"
echo "SETUP COMPLETO! Verifique no GitHub Actions para gerar o APK."
echo "======================================"
