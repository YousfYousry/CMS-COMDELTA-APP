import UIKit
import Flutter
import Firebase
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)

     GMSServices.provideAPIKey("AIzaSyBsBDhToCxcW3B7CBdNX4M-hl1RtvMCLTE")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
