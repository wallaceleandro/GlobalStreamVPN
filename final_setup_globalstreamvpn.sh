#!/bin/bash
echo "====================================="
echo "FINAL SETUP: GlobalStreamVPN Android + Gradle Wrapper + Termux"
echo "====================================="

PROJECT_DIR="$HOME/GlobalStreamVPN"
APP_DIR="$PROJECT_DIR/app"

# Atualiza pacotes
pkg update -y
pkg upgrade -y
pkg install -y git wget unzip openjdk-17 coreutils findutils imagemagick

# Cria estrutura básica do projeto se não existir
mkdir -p "$APP_DIR/src/main/res"
mkdir -p "$APP_DIR/src/main/java/com/globalstreamvpn"
mkdir -p "$APP_DIR/src/main/AndroidManifest.xml"

# Cria gradle.properties se não existir
PROPERTIES_FILE="$PROJECT_DIR/gradle.properties"
if [ ! -f "$PROPERTIES_FILE" ]; then
    cat <<EOF > "$PROPERTIES_FILE"
android.useAndroidX=true
android.enableJetifier=true
kotlin.jvm.target=17
android.suppressUnsupportedCompileSdk=34
EOF
fi

# Corrige AndroidManifest.xml
MANIFEST_FILE="$APP_DIR/src/main/AndroidManifest.xml"
cat <<EOF > "$MANIFEST_FILE"
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.globalstreamvpn">

    <application
        android:allowBackup="true"
        android:label="GlobalStreamVPN"
        android:icon="@mipmap/ic_launcher"
        android:roundIcon="@mipmap/ic_launcher"
        android:supportsRtl="true"
        android:theme="@style/Theme.AppCompat.Light.NoActionBar">
        
        <activity android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        
    </application>
</manifest>
EOF

# Criação das pastas mipmap corretas
for dpi in mdpi hdpi xhdpi xxhdpi xxxhdpi; do
    mkdir -p "$APP_DIR/src/main/res/mipmap-$dpi"
done

# Cria ic_launcher.png base azul
ICON_SRC="$PROJECT_DIR/ic_launcher.png"
if [ ! -f "$ICON_SRC" ]; then
    magick -size 512x512 xc:blue "$ICON_SRC"
fi

# Gera os ícones nas pastas corretas
magick "$ICON_SRC" -resize 48x48 "$APP_DIR/src/main/res/mipmap-mdpi/ic_launcher.png"
magick "$ICON_SRC" -resize 72x72 "$APP_DIR/src/main/res/mipmap-hdpi/ic_launcher.png"
magick "$ICON_SRC" -resize 96x96 "$APP_DIR/src/main/res/mipmap-xhdpi/ic_launcher.png"
magick "$ICON_SRC" -resize 144x144 "$APP_DIR/src/main/res/mipmap-xxhdpi/ic_launcher.png"
magick "$ICON_SRC" -resize 192x192 "$APP_DIR/src/main/res/mipmap-xxxhdpi/ic_launcher.png"

# Cria Gradle Wrapper
cd "$PROJECT_DIR"
./gradlew wrapper --gradle-version 8.3 --distribution-type all

# Build local de teste
./gradlew clean assembleDebug

echo "====================================="
echo "FINAL SETUP COMPLETO! APK pronto em app/build/outputs/apk/debug/"
echo "====================================="
