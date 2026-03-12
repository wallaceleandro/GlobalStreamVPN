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
