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
