import AVFoundation
import AVKit
import Flutter
import MediaPlayer
import UIKit

// MARK: - Shared playback engine

final class CastPlaybackEngine {
  static let shared = CastPlaybackEngine()

  let player = AVPlayer()
  private(set) lazy var playerViewController: AVPlayerViewController = {
    let vc = AVPlayerViewController()
    vc.player = player
    vc.showsPlaybackControls = true
    vc.allowsPictureInPicturePlayback = true
    return vc
  }()

  private init() {
    player.allowsExternalPlayback = true
    player.usesExternalPlaybackWhileExternalScreenIsActive = true
    try? AVAudioSession.sharedInstance().setCategory(
      .playback,
      mode: .moviePlayback,
      options: [.allowAirPlay, .allowBluetoothA2DP]
    )
    try? AVAudioSession.sharedInstance().setActive(true)
  }

  func load(filePath: String?, urlString: String?) {
    let url: URL?
    if let filePath, !filePath.isEmpty {
      url = URL(fileURLWithPath: filePath)
    } else if let urlString, let remote = URL(string: urlString) {
      url = remote
    } else {
      url = nil
    }
    guard let url else { return }
    let item = AVPlayerItem(url: url)
    player.replaceCurrentItem(with: item)
    player.play()
  }

  func play() { player.play() }
  func pause() { player.pause() }

  func toggle() {
    if player.timeControlStatus == .playing {
      player.pause()
    } else {
      player.play()
    }
  }

  func seek(seconds: Double) {
    let time = CMTime(seconds: seconds, preferredTimescale: 600)
    player.seek(to: time)
  }

  func skip(seconds: Double) {
    let current = player.currentTime().seconds
    guard current.isFinite else { return }
    seek(seconds: max(0, current + seconds))
  }

  func stop() {
    player.pause()
    player.replaceCurrentItem(with: nil)
  }

  var status: [String: Any] {
    let item = player.currentItem
    let duration = item?.duration.seconds ?? 0
    let position = player.currentTime().seconds
    return [
      "isPlaying": player.timeControlStatus == .playing,
      "position": position.isFinite ? position : 0,
      "duration": duration.isFinite ? duration : 0,
      "external": player.isExternalPlaybackActive,
    ]
  }
}

// MARK: - Player method channel

final class CastPlayerPlugin: NSObject, FlutterPlugin {
  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "com.casttotv.castscreenmirroring/player",
      binaryMessenger: registrar.messenger()
    )
    let instance = CastPlayerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let engine = CastPlaybackEngine.shared
    switch call.method {
    case "load":
      let args = call.arguments as? [String: Any]
      engine.load(
        filePath: args?["filePath"] as? String,
        urlString: args?["url"] as? String
      )
      result(true)
    case "play":
      engine.play()
      result(true)
    case "pause":
      engine.pause()
      result(true)
    case "toggle":
      engine.toggle()
      result(true)
    case "seek":
      let seconds = (call.arguments as? [String: Any])?["seconds"] as? Double ?? 0
      engine.seek(seconds: seconds)
      result(true)
    case "skip":
      let seconds = (call.arguments as? [String: Any])?["seconds"] as? Double ?? 0
      engine.skip(seconds: seconds)
      result(true)
    case "status":
      result(engine.status)
    case "stop":
      engine.stop()
      result(true)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

enum CastPlayerPluginRegistrar {
  static func register(with registry: FlutterPluginRegistry) {
    guard let registrar = registry.registrar(forPlugin: "CastPlayerPlugin") else { return }
    CastPlayerPlugin.register(with: registrar)
  }
}

// MARK: - Route picker + player views

final class CastRoutePickerViewFactory: NSObject, FlutterPlatformViewFactory {
  private weak var messenger: FlutterBinaryMessenger?

  init(messenger: FlutterBinaryMessenger?) {
    self.messenger = messenger
  }

  func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    CastRoutePickerPlatformView(frame: frame)
  }

  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    FlutterStandardMessageCodec.sharedInstance()
  }
}

final class CastRoutePickerPlatformView: NSObject, FlutterPlatformView {
  private let containerView: UIView

  init(frame: CGRect) {
    let routePickerView = AVRoutePickerView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    routePickerView.activeTintColor = UIColor.systemBlue
    routePickerView.tintColor = UIColor.label

    containerView = UIView(frame: frame)
    containerView.backgroundColor = .clear
    routePickerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(routePickerView)

    NSLayoutConstraint.activate([
      routePickerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      routePickerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      routePickerView.widthAnchor.constraint(equalToConstant: 44),
      routePickerView.heightAnchor.constraint(equalToConstant: 44),
    ])

    super.init()
  }

  func view() -> UIView {
    containerView
  }
}

final class CastVideoPlayerViewFactory: NSObject, FlutterPlatformViewFactory {
  private weak var messenger: FlutterBinaryMessenger?

  init(messenger: FlutterBinaryMessenger?) {
    self.messenger = messenger
  }

  func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    CastVideoPlayerPlatformView(frame: frame, arguments: args)
  }

  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    FlutterStandardMessageCodec.sharedInstance()
  }
}

final class CastVideoPlayerPlatformView: NSObject, FlutterPlatformView {
  private let containerView: UIView

  init(frame: CGRect, arguments: Any?) {
    let engine = CastPlaybackEngine.shared
    let playerVC = engine.playerViewController
    playerVC.view.frame = frame

    if let args = arguments as? [String: Any] {
      let filePath = args["filePath"] as? String
      let url = args["url"] as? String
      if filePath != nil || url != nil {
        engine.load(filePath: filePath, urlString: url)
      }
    }

    containerView = UIView(frame: frame)
    containerView.backgroundColor = .black
    let playerView = playerVC.view!
    playerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(playerView)
    NSLayoutConstraint.activate([
      playerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      playerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      playerView.topAnchor.constraint(equalTo: containerView.topAnchor),
      playerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
    ])

    super.init()
  }

  func view() -> UIView {
    containerView
  }
}

enum CastAirPlayPlugin {
  static func register(with registry: FlutterPluginRegistry) {
    guard let registrar = registry.registrar(forPlugin: "CastAirPlayPlugin") else {
      return
    }

    registrar.register(
      CastRoutePickerViewFactory(messenger: registrar.messenger()),
      withId: "CastRoutePickerView"
    )
    registrar.register(
      CastVideoPlayerViewFactory(messenger: registrar.messenger()),
      withId: "CastVideoPlayerView"
    )
  }
}
