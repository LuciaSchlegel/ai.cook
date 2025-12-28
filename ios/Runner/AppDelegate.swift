import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var foundationModelsChannel: FoundationModelsChannel?
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    GeneratedPluginRegistrant.register(with: self)
    
    // Get the Flutter view controller
    guard let controller = window?.rootViewController as? FlutterViewController else {
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // Register Foundation Models channel
    foundationModelsChannel = FoundationModelsChannel()
    foundationModelsChannel?.registerWith(controller: controller)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
