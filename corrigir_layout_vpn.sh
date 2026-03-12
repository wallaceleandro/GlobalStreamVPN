#!/data/data/com.termux/files/usr/bin/bash

echo "======================================"
echo "CORRIGINDO LAYOUT DO APP"
echo "GlobalStreamVPN"
echo "======================================"

PROJECT=~/GlobalStreamVPN
LAYOUT=$PROJECT/app/src/main/res/layout

mkdir -p $LAYOUT

echo "Recriando activity_main.xml..."

cat > $LAYOUT/activity_main.xml <<'EOF'
<?xml version="1.0" encoding="utf-8"?>

<LinearLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical"
    android:gravity="center"
    android:padding="24dp"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <TextView
        android:id="@+id/title"
        android:text="GlobalStreamVPN"
        android:textSize="26sp"
        android:textStyle="bold"
        android:layout_marginBottom="30dp"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"/>

    <Button
        android:id="@+id/btnConnect"
        android:text="Conectar VPN"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"/>

    <Button
        android:id="@+id/btnDisconnect"
        android:text="Desconectar VPN"
        android:layout_marginTop="16dp"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"/>

</LinearLayout>
EOF

echo "--------------------------------------"
echo "Limpando cache do Gradle"
echo "--------------------------------------"

cd $PROJECT

./gradlew clean

echo "======================================"
echo "LAYOUT CORRIGIDO"
echo "======================================"
echo "Agora envie novamente para o GitHub"
