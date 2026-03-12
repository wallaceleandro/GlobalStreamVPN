#!/bin/bash
set -e

echo "======================================"
echo "FINAL SETUP: GlobalStreamVPN Android + Gradle Wrapper + GitHub Actions"
echo "======================================"

# Configurações
PROJECT="GlobalStreamVPN"
GITHUB_USER="wallaceleandro"
BASE_DIR="$HOME/$PROJECT"
GRADLE_VERSION="8.3"
JAVA_VERSION="17"

# 1️⃣ Instalar pacotes essenciais
echo "Instalando pacotes essenciais..."
pkg update -y && pkg upgrade -y
pkg install git wget unzip openjdk-$JAVA_VERSION coreutils findutils which -y

# Configurar JAVA_HOME
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
export PATH=$JAVA_HOME/bin:$PATH

# 2️⃣ Baixar Gradle se não existir
if [ ! -d "$HOME/gradle" ]; then
  echo "Baixando Gradle $GRADLE_VERSION..."
  cd $HOME
  wget -q https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip
  unzip -q gradle-$GRADLE_VERSION-bin.zip
  rm gradle-$GRADLE_VERSION-bin.zip
  mv gradle-$GRADLE_VERSION gradle
fi
export PATH=$HOME/gradle/bin:$PATH
echo "Gradle instalado: $(gradle -v | head -n 1)"

# 3️⃣ Criar projeto Android mínimo se não existir
echo "Criando/Verificando estrutura do projeto..."
mkdir -p $BASE_DIR/app/src/main/java/com/globalstreamvpn
mkdir -p $BASE_DIR/app/src/main/res/layout
mkdir -p $BASE_DIR/app/src/main/res/values
mkdir -p $BASE_DIR/gradle/wrapper
mkdir -p $BASE_DIR/.github/workflows

cd $BASE_DIR

# 4️⃣ Corrigir build.gradle e namespace
cat <<EOF > app/build.gradle
plugins {
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android' version '1.9.10' apply false
}

android {
    namespace "com.globalstreamvpn"
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

# 5️⃣ Gradle Wrapper completo
echo "Gerando Gradle Wrapper completo..."
gradle wrapper --gradle-version $GRADLE_VERSION --distribution-type all
chmod +x gradlew

# 6️⃣ AndroidManifest, MainActivity, Layout
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

# 8️⃣ Workflow atualizado GitHub Actions (upload-artifact v4)
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

# 9️⃣ Teste build local
echo "Testando build local..."
./gradlew clean assembleDebug

if [ -f "app/build/outputs/apk/debug/app-debug.apk" ]; then
    echo "APK gerado com sucesso localmente!"
else
    echo "Erro: APK não foi gerado. Verifique logs do Gradle."
    exit 1
fi

# 10️⃣ Inicializar Git e push final
echo "Configurando Git e push para GitHub..."
git init
git add .
git commit -m "Projeto Android VPN final + Gradle Wrapper + namespace + GitHub Actions"

git remote add origin https://github.com/$GITHUB_USER/$PROJECT.git || true
git fetch origin || true
git pull origin main --allow-unrelated-histories || true

git branch -M main
git push -u origin main --force

echo "======================================"
echo "PROJETO ANDROID VPN FINALIZADO!"
echo "APK local gerado e repositório atualizado no GitHub."
echo "Workflow GitHub Actions pronto para gerar APK também."
echo "======================================"
