#!/data/data/com.termux/files/usr/bin/bash

echo "======================================"
echo "LIMPEZA PROFUNDA DO PROJETO ANDROID"
echo "GlobalStreamVPN"
echo "======================================"

PROJECT=~/GlobalStreamVPN
APP=$PROJECT/app

cd $PROJECT || exit

echo "Removendo caches problemáticos..."

rm -rf .gradle
rm -rf build
rm -rf $APP/build
rm -rf ~/.gradle

echo "Caches removidos"

echo "--------------------------------------"
echo "Corrigindo gradle.properties"
echo "--------------------------------------"

cat > gradle.properties <<EOF
android.useAndroidX=true
android.enableJetifier=true
android.suppressUnsupportedCompileSdk=34
kotlin.code.style=official
org.gradle.jvmargs=-Xmx2048m
EOF

echo "gradle.properties corrigido"

echo "--------------------------------------"
echo "Corrigindo AndroidManifest"
echo "--------------------------------------"

MANIFEST=$APP/src/main/AndroidManifest.xml

cat > $MANIFEST <<EOF
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.globalstreamvpn">

    <application
        android:allowBackup="true"
        android:label="GlobalStreamVPN"
        android:icon="@mipmap/ic_launcher"
        android:roundIcon="@mipmap/ic_launcher"
        android:supportsRtl="true">

        <activity
            android:name=".MainActivity"
            android:exported="true">

            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>

            </intent-filter>

        </activity>

    </application>

</manifest>
EOF

echo "AndroidManifest corrigido"

echo "--------------------------------------"
echo "Criando ícones obrigatórios"
echo "--------------------------------------"

RES=$APP/src/main/res

mkdir -p $RES/mipmap-mdpi
mkdir -p $RES/mipmap-hdpi
mkdir -p $RES/mipmap-xhdpi
mkdir -p $RES/mipmap-xxhdpi
mkdir -p $RES/mipmap-xxxhdpi

magick -size 512x512 xc:blue icon.png

magick icon.png -resize 48x48 $RES/mipmap-mdpi/ic_launcher.png
magick icon.png -resize 72x72 $RES/mipmap-hdpi/ic_launcher.png
magick icon.png -resize 96x96 $RES/mipmap-xhdpi/ic_launcher.png
magick icon.png -resize 144x144 $RES/mipmap-xxhdpi/ic_launcher.png
magick icon.png -resize 192x192 $RES/mipmap-xxxhdpi/ic_launcher.png

rm icon.png

echo "Ícones criados"

echo "--------------------------------------"
echo "Corrigindo Kotlin JVM"
echo "--------------------------------------"

APPBUILD=$APP/build.gradle

sed -i 's/jvmTarget = "21"/jvmTarget = "17"/g' $APPBUILD
sed -i 's/jvmTarget = "20"/jvmTarget = "17"/g' $APPBUILD

echo "Kotlin JVM corrigido"

echo "--------------------------------------"
echo "Atualizando Gradle Wrapper"
echo "--------------------------------------"

./gradlew wrapper --gradle-version 8.3

echo "Gradle atualizado"

echo "--------------------------------------"
echo "TESTANDO BUILD LOCAL"
echo "--------------------------------------"

./gradlew clean
./gradlew assembleDebug

echo "======================================"
echo "PROJETO CORRIGIDO"
echo "======================================"

echo "APK gerado em:"
echo "app/build/outputs/apk/debug/app-debug.apk"
