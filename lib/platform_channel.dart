import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class PlatformChannel {
  /// ประกาศชื่อช่อง channel
  static const MethodChannel _methodChannel = MethodChannel('sample.test.rtmp/camera');
  static const MethodChannel _methodChannelIos = MethodChannel('plugins.felix.angelov/textview');
  // static const EventChannel _eventChannel = const EventChannel('sample.test.platform/number');

  /// MethodChannel com.test.platform/text
  Future<int?> startService() async {
    return await _methodChannelIos.invokeMethod<int>('startService');
  }

  Future<String?> startStream(Uri url) async {
    return await _methodChannel.invokeMethod<String>('startStream', {"url": url.toString()});
  }

  Future<String?> stopStream() async {
    return await _methodChannel.invokeMethod<String>('stopStream');
  }

  Future<String?> addOverlay(Uint8List data, int filterPosition) async {
    return await _methodChannel.invokeMethod<String>('addOverlay', {"img": data, "filterPosition": filterPosition});
  }

  Future<String?> delOverlay(int filterPosition) async {
    return await _methodChannel.invokeMethod<String>('delOverlay', {"filterPosition": filterPosition});
  }
}

typedef TextViewCreatedCallback = void Function(TextViewController controller);

class TextView extends StatefulWidget {
  const TextView({
    Key? key,
    required this.onTextViewCreated,
  }) : super(key: key);

  final TextViewCreatedCallback onTextViewCreated;

  @override
  State<StatefulWidget> createState() => _TextViewState();
}

class _TextViewState extends State<TextView> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: 'plugins.felix.angelov/textview',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: 'MagicPlatformView',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    return Text('${Platform.operatingSystem} is not yet supported by the text_view plugin');
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onTextViewCreated == null) {
      return;
    }
    widget.onTextViewCreated(TextViewController._(id));
  }
}

class TextViewController {
  TextViewController._(int id) : _channel = MethodChannel('plugins.felix.angelov/textview_$id');

  final MethodChannel _channel;

  Future<void> startService() async {
    // assert(text != null);
    return _channel.invokeMethod('startService');
  }
}
