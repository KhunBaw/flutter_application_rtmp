package com.example.flutter_application_3

import android.util.Log
import com.pedro.rtmp.utils.ConnectCheckerRtmp

class RtmpConnectCheckerRtmp(): ConnectCheckerRtmp {
    override fun onAuthErrorRtmp() {
        Log.d("RtmpConnectCheckerRtmp","onAuthErrorRtmp")
    }

    override fun onAuthSuccessRtmp() {
        Log.d("RtmpConnectCheckerRtmp","onAuthSuccessRtmp")
    }

    override fun onConnectionFailedRtmp(reason: String) {
        Log.d("RtmpConnectCheckerRtmp","onConnectionFailedRtmp")
    }

    override fun onConnectionStartedRtmp(rtmpUrl: String) {
        Log.d("RtmpConnectCheckerRtmp","onConnectionStartedRtmp")
    }

    override fun onConnectionSuccessRtmp() {
        Log.d("RtmpConnectCheckerRtmp","onConnectionSuccessRtmp")
    }

    override fun onDisconnectRtmp() {
        Log.d("RtmpConnectCheckerRtmp","onDisconnectRtmp")
    }

    override fun onNewBitrateRtmp(bitrate: Long) {
        Log.d("RtmpConnectCheckerRtmp","onNewBitrateRtmp")
    }

}