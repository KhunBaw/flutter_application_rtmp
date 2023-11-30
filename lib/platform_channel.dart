import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// class PlatformChannel {
//   /// ประกาศชื่อช่อง channel
//   static const MethodChannel _methodChannel = MethodChannel('sample.test.rtmp/camera');
//   // static const MethodChannel _methodChannelIos = MethodChannel('plugins.felix.angelov/textview');
//   // static const EventChannel _eventChannel = const EventChannel('sample.test.platform/number');

//   /// MethodChannel com.test.platform/text
//   Future<int?> startService() async {
//     return await _methodChannel.invokeMethod<int>('startService');
//   }

//   Future<String?> startStream(Uri url) async {
//     return await _methodChannel.invokeMethod<String>('startStream', {"url": url.toString()});
//   }

//   Future<String?> stopStream() async {
//     return await _methodChannel.invokeMethod<String>('stopStream');
//   }

//   Future<String?> addOverlay(Uint8List data, int filterPosition) async {
//     return await _methodChannel.invokeMethod<String>('addOverlay', {"img": data, "filterPosition": filterPosition});
//   }

//   Future<String?> delOverlay(int filterPosition) async {
//     return await _methodChannel.invokeMethod<String>('delOverlay', {"filterPosition": filterPosition});
//   }
// }

typedef TextViewCreatedCallback = void Function(RootEncoderViewController controller);

class TextView extends StatefulWidget {
  const TextView({
    super.key,
    required this.onTextViewCreated,
  });

  final TextViewCreatedCallback? onTextViewCreated;

  @override
  State<StatefulWidget> createState() => _TextViewState();
}

class _TextViewState extends State<TextView> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: 'plugins.digitopolis.RootEncoder',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: 'plugins.digitopolis.RootEncoder',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    return Text('${Platform.operatingSystem} is not yet supported by the text_view plugin');
  }

  void _onPlatformViewCreated(int id) {
    print("id: ${id}");
    if (widget.onTextViewCreated == null) {
      return;
    }
    widget.onTextViewCreated!(RootEncoderViewController(id));
  }
}

class RootEncoderViewController {
  // RootEncoderViewController._(int id) : _channel = MethodChannel('plugins.digitopolis.RootEncoder/textview_$id');

  late MethodChannel _channel;

  RootEncoderViewController(int id) {
    _channel = MethodChannel('plugins.digitopolis.RootEncoder/textview_$id');
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'sendFromNative':
        String text = call.arguments as String;
        return Future.value("Text from native: $text");
    }
  }

  Future<void> startPreview() async {
    // assert(text != null);
    await _channel.invokeMethod('startPreview');
  }

  Future<String?> startStream(Uri url) async {
    // assert(text != null);
    var data = await _channel.invokeMethod('startStream', {"url": url.toString()});
    print(data);
    return data;
  }

  Future<String?> stopStream() async {
    // assert(text != null);
    var data = await _channel.invokeMethod('stopStream');
    print(data);
    return data;
  }

  Future<void> switchCamera() async {
    // assert(text != null);
    await _channel.invokeMethod('switchCamera');
  }

  Future<String?> addOverlay({required Uint8List data, required int filterPosition}) async {
    // assert(text != null);
    var datas = await _channel.invokeMethod('addOverlay', {"img": data, "filterPosition": filterPosition});
    print(datas);
    return datas;
  }
}
