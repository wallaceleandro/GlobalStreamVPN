package com.globalstreamvpn.vpn;

import com.globalstreamvpn.config.AppConfig;
import com.globalstreamvpn.utils.Logger;

public class WGManager {

    private static String currentServer = AppConfig.SERVER1;

    public static String getServer() {
        return currentServer;
    }

    public static void switchServer(String server) {
        Logger.info("Trocando servidor para: " + server);
        currentServer = server;
    }

    // Escolha automática: se estiver com 98% de uso, muda para outro
    public static void checkAndSwitch(int usagePercent) {
        if (usagePercent >= 98) {
            if (currentServer.equals(AppConfig.SERVER1)) switchServer(AppConfig.SERVER2);
            else if (currentServer.equals(AppConfig.SERVER2)) switchServer(AppConfig.SERVER3);
            else if (currentServer.equals(AppConfig.SERVER3)) switchServer(AppConfig.SERVER4);
            else if (currentServer.equals(AppConfig.SERVER4)) switchServer(AppConfig.SERVER5);
            else switchServer(AppConfig.SERVER1);
        }
    }
}
