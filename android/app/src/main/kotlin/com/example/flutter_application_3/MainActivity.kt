package com.example.flutter_application_3

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.BitmapFactory
import android.util.Log
import android.view.View
import androidx.annotation.NonNull
import com.pedro.encoder.input.gl.render.filters.`object`.ImageObjectFilterRender
import com.pedro.encoder.input.video.CameraHelper
import com.pedro.library.rtmp.RtmpCamera1
import com.pedro.library.view.OpenGlView
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
import kotlin.properties.Delegates


class MainActivity: FlutterActivity() {
    private lateinit var dataAll: DataAll

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

//        RootEncoderPlugin();
        dataAll = DataAll()

        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(
                "plugins.felix.angelov/textview", TextViewFactory(flutterEngine.dartExecutor.binaryMessenger,dataAll));


//        dataAll.openGlView = findViewById(dataAll.openGlViewID)

        LiveStreamNativeView(applicationContext,dataAll,flutterEngine.dartExecutor.binaryMessenger);
        
        /// เดี๋ยวมาเพิ่ม EventChannel ตรงนี้
    }
}

class DataAll(){
    lateinit var rtmpConnectCheckerRtmp: RtmpConnectCheckerRtmp
    var openGlViewID by Delegates.notNull<Int>()
    lateinit var openGlView: OpenGlView
}


class LiveStreamNativeView(private val context: Context,private val dataAll: DataAll, messenger: BinaryMessenger):
      MethodChannel.MethodCallHandler {

    private var channel: MethodChannel = MethodChannel(messenger, "sample.test.rtmp/camera")

    private lateinit var camera: RtmpCamera1
//    private lateinit var imageObjectFilterRender: ImageObjectFilterRender



    init {
        channel.setMethodCallHandler(this)
        dataAll.rtmpConnectCheckerRtmp = RtmpConnectCheckerRtmp()
        dataAll.openGlView = OpenGlView(context)
    }

    @SuppressLint("SuspiciousIndentation")
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "startService"){
            try {
                camera = RtmpCamera1(dataAll.openGlView, dataAll.rtmpConnectCheckerRtmp)
                camera.startPreview(CameraHelper.Facing.FRONT, 90)
                result.success(dataAll.openGlViewID)
            }catch (e: IOException){
                Log.e("error startService","startService error")
                if (e.message != null){
                    result.error("startService", e.message,e)
                }
            }
        }else if (call.method == "startStream") {
            val url =  call.argument<String>("url")
                if (camera.prepareAudio() && camera.prepareVideo()) {
                    camera.startStream(url);
                    camera.startPreview()
                    result.success("startStream success")
                    Log.d("startStream", "startStream success")
                } else {
                    /**This device cant init encoders, this could be for 2 reasons: The encoder selected doesnt support any configuration setted or your device hasnt a H264 or AAC encoder (in this case you can see log error valid encoder not found)*/
                    result.error("camera", "startStream", "startStream error")
                    Log.d("startStream", "startStream error")
                }

        }else if(call.method == "stopStream") {
            camera.stopStream();
            result.success("stopStream success")
        }else if(call.method == "addOverlay"){
            val img =  call.argument<ByteArray>("img")
            val filterPosition =  call.argument<Int>("filterPosition")
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
                        dataAll.openGlView.addFilter(filterPosition,imageObjectFilterRender)
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
        }else if(call.method == "delOverlay") {
            try {
                val filterPosition =  call.argument<Int>("filterPosition")
                if (filterPosition != null && dataAll.openGlView.filtersCount() > 0) {
//                    dataAll.openGlView.filtersCount()
                    dataAll.openGlView.removeFilter(filterPosition)
                    Log.d("overlay", "delOverlay success")
                    result.success("delOverlay success")
                }else{
                    Log.d("overlay", "delOverlay error")
                    result.success("delOverlay error")
                }
            }catch (e: IOException){
                Log.e("error delOverlay","add overlay error")
                if (e.message != null){
                    result.error("delOverlay", e.message,e)
                }
            }

        } else {
            // ถ้าเรา invokeMethod ที่ไม่ได้รองรับ
            result.notImplemented()
        }
    }

}

class TextViewFactory(private val messenger: BinaryMessenger,private val dataAll: DataAll) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, id: Int, o: Any?): PlatformView {
        dataAll.openGlViewID = id
        return FlutterTextView(context, messenger, id,dataAll)
    }
}

class FlutterTextView internal constructor(
    context: Context?,
    messenger: BinaryMessenger?,
    id: Int,
    private val dataAll: DataAll
) :
    PlatformView, MethodCallHandler {
    private val methodChannel: MethodChannel

    init {
        dataAll.openGlView = OpenGlView(context)
        methodChannel = MethodChannel(messenger!!, "plugins.felix.angelov/textview_$id")
        methodChannel.setMethodCallHandler(this)
    }

    override fun getView(): View? {
        return dataAll.openGlView
    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when (methodCall.method) {
//            "setText" -> setText(methodCall, result)
            else -> result.notImplemented()
        }
    }


    override fun dispose() {}
}