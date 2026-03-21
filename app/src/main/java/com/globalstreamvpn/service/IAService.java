package com.globalstreamvpn.service;

import com.globalstreamvpn.utils.Logger;
import com.globalstreamvpn.vpn.WGManager;

public class IAService {

    public static String conectarVPN(boolean automatico) {
        Logger.info("Iniciando conexão VPN com servidor: " + WGManager.getServer());
        // Simulação de conexão
        boolean sucesso = true; // aqui seria o método real de conexão

        if (!sucesso && automatico) {
            Logger.info("Falha detectada, alternando servidor automaticamente...");
            WGManager.checkAndSwitch(99);
            return "Conexão falhou, trocando servidor para: " + WGManager.getServer();
        }

        return "Conectado ao servidor: " + WGManager.getServer();
    }
}
