import Flutter
//import RootEncoder
//import rtmp

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

//
//class WebViewFactory: NSObject, FlutterPlatformViewFactory {
//    
//    private var messenger: FlutterBinaryMessenger
//
//    init(messenger: FlutterBinaryMessenger) {
//        self.messenger = messenger
//        super.init()
//    }
//
//    func create(
//        withFrame frame: CGRect,
//        viewIdentifier viewId: Int64,
//        arguments args: Any?
//    ) -> FlutterPlatformView {
//        return FlutterView(
//            frame: frame,
//            viewIdentifier: viewId,
//            arguments: args,
//            binaryMessenger: messenger)
//    }
//}
//
//
//class FlutterView: NSObject, FlutterPlatformView, ConnectCheckerRtmp {
//    func onConnectionSuccessRtmp() {
//        
//    }
//    
//    func onConnectionFailedRtmp(reason: String) {
//        
//    }
//    
//    func onNewBitrateRtmp(bitrate: UInt64) {
//        
//    }
//    
//    func onDisconnectRtmp() {
//        
//    }
//    
//    func onAuthErrorRtmp() {
//        
//    }
//    
//    func onAuthSuccessRtmp() {
//        
//    }
//    
//    private var _nativeView: UIView
//    private var _methodChannel: FlutterMethodChannel
//    private var rtmpCamera: RtmpCamera!
//    
//    func view() -> UIView {
//        return _nativeView
//    }
//    
//    init(
//        frame: CGRect,
//        viewIdentifier viewId: Int64,
//        arguments args: Any?,
//        binaryMessenger messenger: FlutterBinaryMessenger
//    ) {
//        _nativeView = UIView()
//        _methodChannel = FlutterMethodChannel(name: "plugins.codingwithtashi/flutter_web_view_\(viewId)", binaryMessenger: messenger)
//
//        super.init()
//        
//        rtmpCamera = RtmpCamera(view: _nativeView, connectChecker: self)
//        // iOS views can be created here
//        _methodChannel.setMethodCallHandler(onMethodCall)
//
//    }
//
//
//    func onMethodCall(call: FlutterMethodCall, result: FlutterResult) {
//        switch(call.method){
//        case "setUrl":
////            setText(call:call, result:result)
//            break
//        default:
//            result(FlutterMethodNotImplemented)
//        }
//    }
//   
//    
//}
