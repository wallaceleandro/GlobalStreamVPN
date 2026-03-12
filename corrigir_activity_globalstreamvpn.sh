#!/data/data/com.termux/files/usr/bin/bash

echo "======================================"
echo "CORRIGINDO ACTIVITY DO PROJETO"
echo "GlobalStreamVPN"
echo "======================================"

PROJECT=~/GlobalStreamVPN
SRC=$PROJECT/app/src/main
JAVA=$SRC/java/com/globalstreamvpn
RES=$SRC/res
LAYOUT=$RES/layout

echo "Criando estrutura de pastas..."

mkdir -p $JAVA
mkdir -p $LAYOUT

echo "--------------------------------------"
echo "Criando MainActivity.kt"
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

echo "MainActivity criada"

echo "--------------------------------------"
echo "Criando layout activity_main.xml"
echo "--------------------------------------"

cat > $LAYOUT/activity_main.xml <<'EOF'
<?xml version="1.0" encoding="utf-8"?>

<LinearLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical"
    android:gravity="center"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <TextView
        android:text="GlobalStreamVPN"
        android:textSize="24sp"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"/>

</LinearLayout>
EOF

echo "Layout criado"

echo "--------------------------------------"
echo "Garantindo dependência AppCompat"
echo "--------------------------------------"

APPBUILD=$PROJECT/app/build.gradle

grep -q "appcompat" $APPBUILD || sed -i '/dependencies {/a\    implementation "androidx.appcompat:appcompat:1.6.1"' $APPBUILD

echo "Dependência adicionada"

echo "--------------------------------------"
echo "Limpeza final do projeto"
echo "--------------------------------------"

cd $PROJECT

./gradlew clean

echo "======================================"
echo "CORREÇÃO FINALIZADA"
echo "======================================"
echo "Projeto pronto para build no GitHub"
