package com.globalstreamvpn.utils;

import android.util.Log;

public class Logger {
    private static final String TAG = "GlobalStreamVPN";

    public static void info(String msg) {
        Log.i(TAG, msg);
    }

    public static void erro(String msg) {
        Log.e(TAG, msg);
    }
}
