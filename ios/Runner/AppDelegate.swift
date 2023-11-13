import Flutter
import RootEncoder
import rtmp

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
//    public static func register(with registrar: FlutterPluginRegistrar) {
//            registrar.register(WebViewFactory(messenger: registrar.messenger()), withId: "plugins.felix.angelov/textview")
//    }
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
//      MagicViewPlugin.register(with: )

      
      GeneratedPluginRegistrant.register(with: self)
      
      weak var registrar = self.registrar(forPlugin: "Runner1")
      
      let nativeViewFactory = WebViewFactory(messenger: registrar!.messenger())
      self.registrar(forPlugin: "Runner")!.register(nativeViewFactory, withId: "plugins.felix.angelov/textview")
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}


//public class MagicViewPlugin {
// class func register(with registrar: FlutterPluginRegistrar) {
//   let viewFactory = WebViewFactory(messenger: registrar.messenger())
//   registrar.register(viewFactory, withId: "plugins.felix.angelov/textview")
// }
//}


class WebViewFactory: NSObject, FlutterPlatformViewFactory {
    
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FlutterView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
}


class FlutterView: NSObject, FlutterPlatformView, ConnectCheckerRtmp {
    func onConnectionSuccessRtmp() {
        
    }
    
    func onConnectionFailedRtmp(reason: String) {
        
    }
    
    func onNewBitrateRtmp(bitrate: UInt64) {
        
    }
    
    func onDisconnectRtmp() {
        
    }
    
    func onAuthErrorRtmp() {
        
    }
    
    func onAuthSuccessRtmp() {
        
    }
    
    private var _nativeView: UIView
    private var _methodChannel: FlutterMethodChannel
    private var rtmpCamera: RtmpCamera!
    private var viewID: Int64
    
    func view() -> UIView {
        return _nativeView
    }
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        _nativeView = UIView()
        _methodChannel = FlutterMethodChannel(name: "plugins.felix.angelov/textview_\(viewId)", binaryMessenger: messenger)
        viewID = viewId
        super.init()
        
        rtmpCamera = RtmpCamera(view: _nativeView, connectChecker: self)
        // iOS views can be created here
        _methodChannel.setMethodCallHandler(onMethodCall)

    }


    func onMethodCall(call: FlutterMethodCall, result: FlutterResult) {
        switch(call.method){
        case "startService":
            result(viewID)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
   
    
}
