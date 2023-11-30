package com.example.flutter_application_3

import android.content.Context
import android.graphics.BitmapFactory
import android.view.View
import androidx.annotation.NonNull
import com.pedro.encoder.input.gl.render.filters.`object`.ImageObjectFilterRender
import com.pedro.encoder.input.video.CameraHelper
import com.pedro.encoder.input.video.CameraOpenException
import com.pedro.library.rtmp.RtmpCamera1
import com.pedro.library.view.OpenGlView
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.io.IOException


class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

//        RootEncoderPlugin();

        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(
                "plugins.digitopolis.RootEncoder", TextViewFactory(flutterEngine.dartExecutor.binaryMessenger));

    }
}



//class LiveStreamNativeView(private val context: Context, messenger: BinaryMessenger):
//      MethodChannel.MethodCallHandler {
//
//    private var channel: MethodChannel = MethodChannel(messenger, "sample.test.rtmp/camera")
//
//    private lateinit var camera: RtmpCamera1
////    private lateinit var imageObjectFilterRender: ImageObjectFilterRender
//
//
//
//    init {
//        channel.setMethodCallHandler(this)
////        dataAll.rtmpConnectCheckerRtmp = RtmpConnectCheckerRtmp()
//    }
//
//    @SuppressLint("SuspiciousIndentation")
//    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
//        if (call.method == "startService"){
//            try {
//                camera = RtmpCamera1(dataAll.openGlView, dataAll.rtmpConnectCheckerRtmp)
//                camera.startPreview(CameraHelper.Facing.FRONT, 90)
//                result.success(dataAll.openGlViewID)
//            }catch (e: IOException){
//                Log.e("error startService","startService error")
//                if (e.message != null){
//                    result.error("startService", e.message,e)
//                }
//            }
//        }else if (call.method == "startStream") {
//            val url =  call.argument<String>("url")
//                if (camera.prepareAudio() && camera.prepareVideo()) {
//                    camera.startStream(url);
//                    camera.startPreview()
//                    result.success("startStream success")
//                    Log.d("startStream", "startStream success")
//                } else {
//                    /**This device cant init encoders, this could be for 2 reasons: The encoder selected doesnt support any configuration setted or your device hasnt a H264 or AAC encoder (in this case you can see log error valid encoder not found)*/
//                    result.error("camera", "startStream", "startStream error")
//                    Log.d("startStream", "startStream error")
//                }
//
//        }else if(call.method == "stopStream") {
//            camera.stopStream();
//            result.success("stopStream success")
//        }else if(call.method == "addOverlay"){
//            val img =  call.argument<ByteArray>("img")
//            val filterPosition =  call.argument<Int>("filterPosition")
//            Log.d("overlay", "startAddOverlay")
//            try {
//                if (img != null) {
//                    Log.d("overlay", "AddOverlaySize ${img.size}")
//                    val imageObjectFilterRender =  ImageObjectFilterRender()
//                    imageObjectFilterRender.apply {
//                        setImage(BitmapFactory.decodeByteArray(img, 0, img.size))
//                        setScale(20f, 20f)
//                        setPosition(50f,50f)
//                    }
//
//                    if (filterPosition != null) {
//                        dataAll.openGlView.addFilter(filterPosition,imageObjectFilterRender)
//                    }
//                }
//                Log.d("overlay", "add overlay success")
//                result.success("add overlay success")
//            }catch (e: IOException){
//                Log.e("error add overlay","add overlay error")
//                if (e.message != null){
//                    result.error("add overlay", e.message,e)
//                }
//            }
//        }else if(call.method == "delOverlay") {
//            try {
//                val filterPosition =  call.argument<Int>("filterPosition")
//                if (filterPosition != null && dataAll.openGlView.filtersCount() > 0) {
////                    dataAll.openGlView.filtersCount()
//                    dataAll.openGlView.removeFilter(filterPosition)
//                    Log.d("overlay", "delOverlay success")
//                    result.success("delOverlay success")
//                }else{
//                    Log.d("overlay", "delOverlay error")
//                    result.success("delOverlay error")
//                }
//            }catch (e: IOException){
//                Log.e("error delOverlay","add overlay error")
//                if (e.message != null){
//                    result.error("delOverlay", e.message,e)
//                }
//            }
//
//        } else {
//            // ถ้าเรา invokeMethod ที่ไม่ได้รองรับ
//            result.notImplemented()
//        }
//    }
//
//}

class TextViewFactory(private val messenger: BinaryMessenger) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, id: Int, o: Any?): PlatformView {
        // dataAll.openGlViewID = id
        return FlutterTextView(context, messenger, id)
    }
}

class FlutterTextView internal constructor(
    context: Context?,
    messenger: BinaryMessenger?,
    id: Int,
) :
    PlatformView, MethodCallHandler {

    private val methodChannel: MethodChannel
    private var openGlView: OpenGlView = OpenGlView(context)
    private var rtmpConnectCheckerRtmp: RtmpConnectCheckerRtmp = RtmpConnectCheckerRtmp()
    private var camera: RtmpCamera1 = RtmpCamera1(openGlView, rtmpConnectCheckerRtmp)

    init {
//        camera = RtmpCamera1(openGlView, rtmpConnectCheckerRtmp)
//        camera.startPreview(CameraHelper.Facing.FRONT, 90)

        if (openGlView.holder.surface.isValid) {
                try {
                    camera.startPreview()
                } catch (e: CameraOpenException) {
                    e.printStackTrace()
                    Log.d("startPreview",  e.message!! )
                }

        }

        methodChannel = MethodChannel(messenger!!, "plugins.digitopolis.RootEncoder/textview_$id")
        methodChannel.setMethodCallHandler(this)
    }

    override fun getView(): View? {
        return openGlView
    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when (methodCall.method) {
//            "setText" -> setText(methodCall, result)
            "startPreview" -> {
                camera.startPreview(CameraHelper.Facing.FRONT, 90)
            }
            "startStream" -> {
                val url =  methodCall.argument<String>("url")
                if (camera.prepareAudio() && camera.prepareVideo()) {
                    camera.startStream(url);
                    if (!camera.isOnPreview){
                        camera.startPreview()
                    }
                    result.success("startStream success")
                    Log.d("startStream", "startStream success")
                } else {
                    /**This device cant init encoders, this could be for 2 reasons: The encoder selected doesnt support any configuration setted or your device hasnt a H264 or AAC encoder (in this case you can see log error valid encoder not found)*/
                    result.error("camera", "startStream", "startStream error")
                    Log.d("startStream", "startStream error")
                }
            }
            "stopStream" -> {
                camera.stopStream();
                result.success("stopStream success")
            }
            "addOverlay" -> {
                val img =  methodCall.argument<ByteArray>("img")
                val filterPosition =  methodCall.argument<Int>("filterPosition")
                Log.d("overlay", "startAddOverlay")
                try {
                    if (img != null) {
                        Log.d("overlay", "AddOverlaySize ${img.size}")
                        val imageObjectFilterRender =  ImageObjectFilterRender()
                        imageObjectFilterRender.apply {
                            setImage(BitmapFactory.decodeByteArray(img, 0, img.size))
                            setScale(20f, 20f)
                            setPosition(50f,50f)
                        }

                        if (filterPosition != null) {
                            openGlView.addFilter(filterPosition,imageObjectFilterRender)
                        }
                    }
                    Log.d("overlay", "add overlay success")
                    result.success("add overlay success")
                }catch (e: IOException){
                    Log.e("error add overlay","add overlay error")
                    if (e.message != null){
                        result.error("add overlay", e.message,e)
                        }
                    }
                }
            else -> result.notImplemented()
        }
    }


    override fun dispose() {
    }
}