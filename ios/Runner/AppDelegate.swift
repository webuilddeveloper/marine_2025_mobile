import Flutter
import UIKit
// import GoogleMaps
import Firebase
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure() // <- ✅ ต้องมีบรรทัดนี้
    // GMSServices.provideAPIKey("AIzaSyDPcNbGx51w5cVYGIW1QURDHwmLeMwDD4c")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
