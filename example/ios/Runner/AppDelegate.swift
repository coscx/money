import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let cn: FlutterViewController =  window?.rootViewController as! FlutterViewController;
    GeneratedPluginRegistrant.register(with: self,  flutterViewController: cn)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
