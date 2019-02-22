import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Dailer specific code
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let dialerChannel = FlutterMethodChannel(name: "dev.flutter.dialer/dialer",
                                              binaryMessenger: controller)
    dialerChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: FlutterResult) -> Void in
        let dict = call.arguments as? Dictionary<String, String>
        if let unwrappedDict = dict {
            let numberStr = unwrappedDict["number"]
            if let unwrappedStr = numberStr {
                makeCall(number: unwrappedStr, result: result)
            }
        }
    })
    
    // End of dialer specific code
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

private func makeCall(number: String, result: FlutterResult) {
    guard let urlNumber = URL(string: "tel://" + number) else { return }
    // UIApplication.shared.open(urlNumber)
    UIApplication.shared.openURL(urlNumber)
    result(0)
}
