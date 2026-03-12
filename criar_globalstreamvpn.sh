#!/bin/bash
set -e

echo "======================================"
echo "CONFIGURANDO TERMUX + CRIANDO PROJETO ANDROID VPN COMPLETO"
echo "======================================"

# Configurações
PROJECT="GlobalStreamVPN"
GITHUB_USER="wallaceleandro"
BASE_DIR="$HOME/$PROJECT"
GRADLE_VERSION="8.3"
JAVA_VERSION="17"

# 1️⃣ Instalar dependências
echo "Instalando pacotes essenciais..."
pkg update -y
pkg upgrade -y
pkg install git wget unzip openjdk-$JAVA_VERSION -y

# Configurar Java
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
export PATH=$JAVA_HOME/bin:$PATH

# 2️⃣ Baixar Gradle
echo "Baixando Gradle $GRADLE_VERSION..."
cd $GlobalStreamVPN
wget -q https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip
unzip -q gradle-$GRADLE_VERSION-bin.zip
rm gradle-$GRADLE_VERSION-bin.zip
mv gradle-$GRADLE_VERSION gradle
export PATH=$GlobalStreamVPN/gradle/bin:$PATH
echo "Gradle instalado: $(gradle -v | head -n 1)"

# 3️⃣ Criar projeto Android
echo "Criando pasta do projeto..."
rm -rf $BASE_DIR
mkdir -p $BASE_DIR
cd $BASE_DIR

# Estrutura mínima Android
mkdir -p app/src/main/java/com/globalstreamvpn
mkdir -p app/src/main/res/layout
mkdir -p app/src/main/res/values
mkdir -p gradle/wrapper
mkdir -p .github/workflows

# 4️⃣ Criar arquivos Gradle
cat <<EOF > settings.gradle
rootProject.name = '$PROJECT'
include ':app'
EOF

cat <<EOF > build.gradle
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath "com.android.tools.build:gradle:8.1.0"
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
EOF

mkdir -p app
cat <<EOF > app/build.gradle
plugins {
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android' version '1.9.10' apply false
}

android {
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
        }
    }
}

dependencies {
    implementation "androidx.core:core-ktx:1.12.0"
    implementation "androidx.appcompat:appcompat:1.7.0"
    implementation "com.google.android.material:material:1.11.0"
}
EOF

# 5️⃣ Gerar Gradle Wrapper real
gradle wrapper --gradle-version $GRADLE_VERSION

# 6️⃣ Criar AndroidManifest, MainActivity e layout
cat <<EOF > app/src/main/AndroidManifest.xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.globalstreamvpn">

    <application
        android:label="GlobalStreamVPN"
        android:theme="@android:style/Theme.Material.Light">

        <activity android:name=".MainActivity">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>

    </application>

</manifest>
EOF

cat <<EOF > app/src/main/java/com/globalstreamvpn/MainActivity.kt
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

cat <<EOF > app/src/main/res/layout/activity_main.xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical"
    android:gravity="center"
    android:padding="20dp"
    android:layout_width="match_parent"
    android:layout_height="match_parent">
</LinearLayout>
EOF

# 7️⃣ .gitignore
cat <<EOF > .gitignore
.gradle
/local.properties
/.idea
/build
/captures
.DS_Store
EOF

# 8️⃣ Workflow GitHub Actions atualizado
cat <<EOF > .github/workflows/build.yml
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
    - name: Set up JDK 17
      uses: actions/setup-java@v4
      with:
        java-version: '17'
        distribution: 'temurin'
    - name: Build Debug APK
      run: ./gradlew assembleDebug
    - name: Upload APK
      uses: actions/upload-artifact@v4
      with:
        name: GlobalStreamVPN-debug.apk
        path: app/build/outputs/apk/debug/app-debug.apk
EOF

# 9️⃣ Inicializar Git e push
git init
git add .
git commit -m "Projeto Android VPN completo Termux + Gradle Wrapper + GitHub Actions APK"

git remote add origin https://github.com/$GITHUB_USER/$PROJECT.git
git fetch origin || true
if git rev-parse --verify origin/main >/dev/null 2>&1; then
    git pull origin main --allow-unrelated-histories
fi

git branch -M main
git push -u origin main --force

echo "======================================"
echo "PROJETO ANDROID VPN COMPLETO SUBIDO COM SUCESSO!"
echo "Workflow GitHub Actions pronto para gerar APK automaticamente."
echo "Local do projeto: $BASE_DIR"
echo "======================================"
