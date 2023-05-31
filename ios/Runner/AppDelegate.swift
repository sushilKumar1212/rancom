import UIKit
import Flutter
import Firebase
// import FirebaseMessaging
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyAdOFwxCv9unC7HVDU7B0yIFWZzkNW-oBo")
    GMSServices.setMetalRendererEnabled(true)
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

//   override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

//    Messaging.messaging().apnsToken = deviceToken
//    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
//  }
}

