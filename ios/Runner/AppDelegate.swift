import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    CastAirPlayPlugin.register(with: engineBridge.pluginRegistry)
    CastMirrorPluginRegistrar.register(with: engineBridge.pluginRegistry)
    CastPlayerPluginRegistrar.register(with: engineBridge.pluginRegistry)
  }
}
