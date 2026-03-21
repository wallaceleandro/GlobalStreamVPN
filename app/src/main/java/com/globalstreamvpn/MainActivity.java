package com.globalstreamvpn;

import android.os.Bundle;
import android.widget.*;
import androidx.appcompat.app.AppCompatActivity;

import com.globalstreamvpn.service.IAService;
import com.globalstreamvpn.utils.Logger;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        TextView status = findViewById(R.id.textStatus);
        Button btnConectar = findViewById(R.id.btnConectar);

        btnConectar.setOnClickListener(v -> {
            Logger.info("Botão conectar clicado");
            new Thread(() -> {
                String resultado = IAService.conectarVPN(true);
                runOnUiThread(() -> status.setText(resultado));
            }).start();
        });
    }
}
