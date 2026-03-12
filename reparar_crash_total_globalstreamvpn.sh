#!/data/data/com.termux/files/usr/bin/bash

echo "======================================"
echo "REPARO TOTAL DO APP - GLOBALSTREAMVPN"
echo "======================================"

PROJECT=~/GlobalStreamVPN
APP=$PROJECT/app
SRC=$APP/src/main
JAVA=$SRC/java/com/globalstreamvpn
RES=$SRC/res

cd $PROJECT || exit

echo "--------------------------------------"
echo "Criando estrutura de pastas"
echo "--------------------------------------"

mkdir -p $JAVA
mkdir -p $RES/layout
mkdir -p $RES/values
mkdir -p $RES/mipmap-mdpi
mkdir -p $RES/mipmap-hdpi
mkdir -p $RES/mipmap-xhdpi
mkdir -p $RES/mipmap-xxhdpi
mkdir -p $RES/mipmap-xxxhdpi

echo "--------------------------------------"
echo "Criando MainActivity segura"
echo "--------------------------------------"

cat > $JAVA/MainActivity.kt <<'EOF'
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

echo "--------------------------------------"
echo "Criando layout principal"
echo "--------------------------------------"

cat > $RES/layout/activity_main.xml <<'EOF'
<?xml version="1.0" encoding="utf-8"?>

<LinearLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical"
    android:gravity="center"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <TextView
        android:text="GlobalStreamVPN"
        android:textSize="26sp"
        android:textStyle="bold"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"/>

</LinearLayout>
EOF

echo "--------------------------------------"
echo "Criando theme do app"
echo "--------------------------------------"

cat > $RES/values/styles.xml <<'EOF'
<resources>

    <style name="Theme.GlobalStreamVPN" parent="Theme.AppCompat.Light.DarkActionBar">
        <item name="colorPrimary">#6200EE</item>
        <item name="colorPrimaryDark">#3700B3</item>
        <item name="colorAccent">#03DAC5</item>
    </style>

</resources>
EOF

echo "--------------------------------------"
echo "Criando cores"
echo "--------------------------------------"

cat > $RES/values/colors.xml <<'EOF'
<resources>
    <color name="purple_200">#BB86FC</color>
    <color name="purple_500">#6200EE</color>
    <color name="purple_700">#3700B3</color>
    <color name="teal_200">#03DAC5</color>
</resources>
EOF

echo "--------------------------------------"
echo "Criando AndroidManifest"
echo "--------------------------------------"

cat > $SRC/AndroidManifest.xml <<'EOF'
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <application
        android:label="GlobalStreamVPN"
        android:icon="@mipmap/ic_launcher"
        android:theme="@style/Theme.GlobalStreamVPN">

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

echo "--------------------------------------"
echo "Criando ícones simples"
echo "--------------------------------------"

magick -size 512x512 xc:blue icon.png

magick icon.png -resize 48x48 $RES/mipmap-mdpi/ic_launcher.png
magick icon.png -resize 72x72 $RES/mipmap-hdpi/ic_launcher.png
magick icon.png -resize 96x96 $RES/mipmap-xhdpi/ic_launcher.png
magick icon.png -resize 144x144 $RES/mipmap-xxhdpi/ic_launcher.png
magick icon.png -resize 192x192 $RES/mipmap-xxxhdpi/ic_launcher.png

rm icon.png

echo "--------------------------------------"
echo "Garantindo dependências"
echo "--------------------------------------"

APPBUILD=$APP/build.gradle

grep -q "appcompat" $APPBUILD || sed -i '/dependencies {/a\    implementation "androidx.appcompat:appcompat:1.6.1"' $APPBUILD
grep -q "core-ktx" $APPBUILD || sed -i '/dependencies {/a\    implementation "androidx.core:core-ktx:1.12.0"' $APPBUILD
grep -q "constraintlayout" $APPBUILD || sed -i '/dependencies {/a\    implementation "androidx.constraintlayout:constraintlayout:2.1.4"' $APPBUILD

echo "--------------------------------------"
echo "Limpando build"
echo "--------------------------------------"

./gradlew clean

echo "======================================"
echo "REPARO FINALIZADO"
echo "======================================"
echo "Suba novamente para o GitHub"
