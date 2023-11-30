import Flutter
import RootEncoder
import rtmp
import encoder

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
      
      weak var registrar = self.registrar(forPlugin: "RootEncoder")
      let nativeViewFactory = WebViewFactory(messenger: registrar!.messenger())
//      let viewRegistrar = self.registrar(forPlugin: "RootEncoder1")
      registrar!.register(nativeViewFactory, withId: "plugins.digitopolis.RootEncoder")
      
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
            binaryMessenger: messenger
        )
    }
}


class FlutterView: NSObject, FlutterPlatformView, ConnectCheckerRtmp {
    func onConnectionSuccessRtmp() {
        print("connection success")
    }
    
    func onConnectionFailedRtmp(reason: String) {
        print("connection failed: \(reason)")
        if (rtmpCamera.reTry(delay: 5000, reason: reason)) {
                    
        } else {
        rtmpCamera.stopStream()
        }
    }
    
    func onNewBitrateRtmp(bitrate: UInt64) {
        print("new bitrate: \(bitrate)")
    }
    
    func onDisconnectRtmp() {
        print("disconnected")
    }
    
    func onAuthErrorRtmp() {
        print("auth error")
    }
    
    func onAuthSuccessRtmp() {
        print("auth success")
    }
    
    private var _view: MetalView
    private var _methodChannel: FlutterMethodChannel
    private var rtmpCamera: RtmpCamera!
    private var viewID: Int64
    
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
       
//        _view = UIView(frame: CGRect(x: 0,
//                                     y: 0,
//                                     width: UIScreen.main.bounds.size.width * 0.5,
//                                     height: UIScreen.main.bounds.size.height * 0.5))
//        _view = UIView(frame: CGRect(x: 0,
//                                     y: 0,
//                                     width: 480,
//                                     height: 640))
        _view = MetalView()
        
       

//        _view = UIView()
//        _view.contentMode = UIView.ContentMode.scaleAspectFit
        
//        boxView = UIView(frame: frame)
//        _view = UIView(frame: frame)
       

        _methodChannel = FlutterMethodChannel(name: "plugins.digitopolis.RootEncoder/textview_\(viewId)", binaryMessenger: messenger)
        viewID = viewId
        super.init()
        
        
        
        print("init pro viewId:\(viewId)");
//        _view.frame = frame
        
        rtmpCamera = RtmpCamera(view: _view, connectChecker: self)
        rtmpCamera.startPreview(resolution: .vga640x480, facing: .BACK, rotation: 90)
        _methodChannel.setMethodCallHandler(onMethodCall)
    }
    
    func view() -> UIView {
        return _view
    }

    func onMethodCall(call: FlutterMethodCall, result: FlutterResult) {
        switch(call.method){
        case "startStream":
            if  let args =  call.arguments as? Dictionary<String, Any>,
                    let url = args["url"] as? String {
                if(rtmpCamera.prepareVideo(resolution: .fhd1920x1080, fps: 30, bitrate: 2000, iFrameInterval: 2, rotation: 90) && rtmpCamera.prepareAudio() && !rtmpCamera.isStreaming()){
//                    rtmpCamera.prepareVideo(resolution: .vga640x480, fps: 30, bitrate: 2000, iFrameInterval: 2)
                    rtmpCamera.startStream(endpoint: url)
                }
                result("startStream success")
            } else {
                result(FlutterError.init(code: "bad args", message: nil, details: nil))
              }
        break
         case "stopStream":
            if(rtmpCamera.isStreaming()){
                rtmpCamera.stopStream()
            }
            result("stopStream success")
        break
        case "switchCamera":
            rtmpCamera.switchCamera()
           result("addOverlay success")
       break
         case "addOverlay":
            let args =  call.arguments as? [String:FlutterStandardTypedData]
            if let uintInt8List:FlutterStandardTypedData = args?["img"]{
//                let byte = [UInt8](uintInt8List.data)
                print("add over")
                let image = UIImage(data: uintInt8List.data)
                let filter = FilterRender(imageFlutter: image!)
                _view.addFilter(filter: filter)
                print("add over success")
               result("addOverlay success")
            }
            
                
            
       break
        
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
   
    
}


//public class FilterRender: BaseFilterRender {
//    
////    private let filter = CIFilter(name: "CIColorMonochrome")
//    private let imageFlutters: UIImage
//    
//    public init(imageFlutter: UIImage) {
//        imageFlutters = imageFlutter
//    }
//    
//    public func draw(image: CIImage) -> CIImage {
////        filter?.setValue(CIImage(cgImage: imageFlutters.cgImage!), forKey: "inputImage")
////        imageFlutters?.ciImage
////        filter?.setValue(CIVector(x: 0, y: 0, z: 200, w: 200), forKey: "inputRectangle")
//        
////        filter?.setValue(image, forKey: "inputImage")
////        filter?.setValue(CIColor(red: 0.75, green: 0.75, blue: 0.75), forKey: "inputColor")
////        filter?.setValue(1.0, forKey: "inputIntensity")
////        return filter?.outputImage ?? image
////        return imageFlutters.ciImage ?? CIImage(cgImage: imageFlutters.cgImage! )
//        
//      let drawimage = drawImage(image: imageFlutters, inImage: UIImage(ciImage: image), atPoint: CGPoint(x: 0, y: 0))
//        
//        return CIImage(cgImage: drawimage.cgImage!)
//    }
//    
//    public func drawImage(image foreGroundImage:UIImage, inImage backgroundImage:UIImage, atPoint point:CGPoint) -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(backgroundImage.size, false, 0.0)
//        backgroundImage.draw(in: CGRect.init(x: 0, y: 0, width: backgroundImage.size.width, height: backgroundImage.size.height))
//        foreGroundImage.draw(in: CGRect.init(x: point.x, y: point.y, width: foreGroundImage.size.width, height: foreGroundImage.size.height))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage!
//    }
//    
//}



public class FilterRender: BaseFilterRender {
    
//    private let filter = CIFilter(name: "CIColorMonochrome")
    private let imageFlutters: UIImage
    
    public init(imageFlutter: UIImage) {
        imageFlutters = imageFlutter
    }
    
    public func draw(image: CIImage) -> CIImage {
      let drawimage = drawImage(image: imageFlutters, inImage: UIImage(ciImage: image), atPoint: CGPoint(x: 0, y: 0))
        
        
        return CIImage(cgImage: drawimage.cgImage!)
    }
    
    public func drawImage(image foreGroundImage:UIImage, inImage backgroundImage:UIImage, atPoint point:CGPoint) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(backgroundImage.size, false, 0.0)
        backgroundImage.draw(in: CGRect.init(x: 0, y: 0, width: backgroundImage.size.width, height: backgroundImage.size.height))
        foreGroundImage.draw(in: CGRect.init(x: point.x, y: point.y, width: foreGroundImage.size.width, height: foreGroundImage.size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}
