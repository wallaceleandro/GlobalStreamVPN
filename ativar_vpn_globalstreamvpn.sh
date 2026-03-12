#!/data/data/com.termux/files/usr/bin/bash

echo "======================================"
echo "ATIVANDO FUNCIONALIDADE VPN"
echo "GlobalStreamVPN"
echo "======================================"

PROJECT=~/GlobalStreamVPN
APP=$PROJECT/app
SRC=$APP/src/main
JAVA=$SRC/java/com/globalstreamvpn
RES=$SRC/res

mkdir -p $JAVA
mkdir -p $RES/layout

echo "--------------------------------------"
echo "Criando serviço VPN"
echo "--------------------------------------"

cat > $JAVA/MyVpnService.kt <<'EOF'
package com.globalstreamvpn

import android.app.PendingIntent
import android.content.Intent
import android.net.VpnService
import android.os.ParcelFileDescriptor
import java.io.FileInputStream
import java.io.FileOutputStream

class MyVpnService : VpnService() {

    private var vpnInterface: ParcelFileDescriptor? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

        val builder = Builder()

        builder.setSession("GlobalStreamVPN")
        builder.addAddress("10.0.0.2", 32)
        builder.addRoute("0.0.0.0", 0)

        vpnInterface = builder.establish()

        return START_STICKY
    }

    override fun onDestroy() {
        vpnInterface?.close()
        super.onDestroy()
    }
}
EOF

echo "--------------------------------------"
echo "Criando MainActivity com controle VPN"
echo "--------------------------------------"

cat > $JAVA/MainActivity.kt <<'EOF'
package com.globalstreamvpn

import android.content.Intent
import android.net.VpnService
import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {

    private val VPN_REQUEST_CODE = 100

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.activity_main)

        val btnConnect = findViewById<Button>(R.id.btnConnect)
        val btnDisconnect = findViewById<Button>(R.id.btnDisconnect)

        btnConnect.setOnClickListener {

            val intent = VpnService.prepare(this)

            if (intent != null) {
                startActivityForResult(intent, VPN_REQUEST_CODE)
            } else {
                startVpn()
            }
        }

        btnDisconnect.setOnClickListener {

            stopService(Intent(this, MyVpnService::class.java))
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {

        if (requestCode == VPN_REQUEST_CODE && resultCode == RESULT_OK) {
            startVpn()
        }

        super.onActivityResult(requestCode, resultCode, data)
    }

    private fun startVpn() {

        val intent = Intent(this, MyVpnService::class.java)
        startService(intent)
    }
}
EOF

echo "--------------------------------------"
echo "Criando interface"
echo "--------------------------------------"

cat > $RES/layout/activity_main.xml <<'EOF'
<?xml version="1.0" encoding="utf-8"?>

<LinearLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical"
    android:gravity="center"
    android:padding="24dp"
    android:layout_width="
