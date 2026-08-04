import AVFoundation
import CoreImage
import Flutter
import Network
import ReplayKit
import UIKit

private final class LocalFrameServer {
  private var listener: NWListener?
  private let queue = DispatchQueue(label: "com.casttotv.castscreenmirroring.server", qos: .userInitiated)
  private var connections: [ObjectIdentifier: NWConnection] = [:]
  private var latestFrame: Data?
  private let lock = NSLock()
  let port: UInt16

  init(port: UInt16 = 8765) {
    self.port = port
  }

  var isRunning: Bool { listener != nil }

  func start() throws {
    guard listener == nil else { return }
    let params = NWParameters.tcp
    params.allowLocalEndpointReuse = true
    guard let nwPort = NWEndpoint.Port(rawValue: port) else {
      throw NSError(domain: "LocalFrameServer", code: 1, userInfo: nil)
    }
    let newListener = try NWListener(using: params, on: nwPort)
    newListener.newConnectionHandler = { [weak self] connection in
      self?.accept(connection)
    }
    newListener.start(queue: queue)
    listener = newListener
  }

  func stop() {
    queue.async { [weak self] in
      guard let self else { return }
      for connection in self.connections.values {
        connection.cancel()
      }
      self.connections.removeAll()
      self.listener?.cancel()
      self.listener = nil
    }
  }

  func updateFrame(_ data: Data) {
    lock.lock()
    latestFrame = data
    lock.unlock()
  }

  private func accept(_ connection: NWConnection) {
    let id = ObjectIdentifier(connection)
    connections[id] = connection
    connection.stateUpdateHandler = { [weak self] state in
      switch state {
      case .failed, .cancelled:
        self?.connections.removeValue(forKey: id)
      default:
        break
      }
    }
    connection.start(queue: queue)
    receiveRequest(on: connection)
  }

  private func receiveRequest(on connection: NWConnection) {
    connection.receive(minimumIncompleteLength: 1, maximumLength: 4096) { [weak self] data, _, _, error in
      guard let self else { return }
      if error != nil {
        connection.cancel()
        return
      }
      let request = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
      let path = request.split(separator: "\n").first?.split(separator: " ").dropFirst().first ?? "/"
      if path.hasPrefix("/frame") {
        self.sendFrame(connection)
      } else {
        self.sendViewerPage(connection)
      }
    }
  }

  private func currentFrame() -> Data? {
    lock.lock()
    defer { lock.unlock() }
    return latestFrame
  }

  private func sendViewerPage(_ connection: NWConnection) {
    let html = """
    <!DOCTYPE html><html><head><meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Cast Screen Viewer</title>
    <style>body{margin:0;background:#000;display:flex;align-items:center;justify-content:center;height:100vh}
    img{max-width:100%;max-height:100%;object-fit:contain}</style></head>
    <body><img id="m" alt="Screen"/><script>
    function tick(){document.getElementById('m').src='/frame.jpg?'+Date.now();}
    setInterval(tick,200);tick();
    </script></body></html>
    """
    let body = Data(html.utf8)
    let header = "HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=utf-8\r\nContent-Length: \(body.count)\r\nConnection: close\r\n\r\n"
    connection.send(content: Data(header.utf8) + body, completion: .contentProcessed { _ in
      connection.cancel()
    })
  }

  private func sendFrame(_ connection: NWConnection) {
    guard let frame = currentFrame(), !frame.isEmpty else {
      let header = "HTTP/1.1 204 No Content\r\nConnection: close\r\n\r\n"
      connection.send(content: Data(header.utf8), completion: .contentProcessed { _ in
        connection.cancel()
      })
      return
    }
    let header = "HTTP/1.1 200 OK\r\nContent-Type: image/jpeg\r\nContent-Length: \(frame.count)\r\nCache-Control: no-store\r\nConnection: close\r\n\r\n"
    connection.send(content: Data(header.utf8) + frame, completion: .contentProcessed { _ in
      connection.cancel()
    })
  }
}

private final class ScreenCaptureCoordinator {
  static let shared = ScreenCaptureCoordinator()

  private let recorder = RPScreenRecorder.shared()
  private let server = LocalFrameServer()
  private let ciContext = CIContext()
  private var isCapturing = false
  private var lastFrameTime: CFTimeInterval = 0
  private let minFrameInterval: CFTimeInterval = 0.15

  private init() {}

  var isWifiMirrorActive: Bool { isCapturing && server.isRunning }

  func isAirPlayMirrorActive() -> Bool {
    UIScreen.screens.count > 1
  }

  func startWifiMirror(completion: @escaping (Result<String, Error>) -> Void) {
    guard recorder.isAvailable else {
      completion(.failure(NSError(
        domain: "ScreenCapture",
        code: 1,
        userInfo: [NSLocalizedDescriptionKey: "Screen recording is not available on this device."]
      )))
      return
    }

    do {
      try server.start()
    } catch {
      completion(.failure(error))
      return
    }

    recorder.startCapture(handler: { [weak self] sampleBuffer, bufferType, error in
      guard let self, bufferType == .video, error == nil else { return }
      let now = CACurrentMediaTime()
      guard now - self.lastFrameTime >= self.minFrameInterval else { return }
      self.lastFrameTime = now
      if let jpeg = self.jpegData(from: sampleBuffer) {
        self.server.updateFrame(jpeg)
      }
    }, completionHandler: { [weak self] error in
      guard let self else { return }
      if let error {
        self.server.stop()
        completion(.failure(error))
        return
      }
      self.isCapturing = true
      guard let url = self.mirrorURL() else {
        self.stopWifiMirror()
        completion(.failure(NSError(
          domain: "ScreenCapture",
          code: 2,
          userInfo: [NSLocalizedDescriptionKey: "Could not determine device IP address."]
        )))
        return
      }
      completion(.success(url))
    })
  }

  func stopWifiMirror() {
    if isCapturing {
      recorder.stopCapture { _ in }
    }
    isCapturing = false
    server.stop()
    server.updateFrame(Data())
  }

  func mirrorURL() -> String? {
    guard let ip = localIPAddress() else { return nil }
    return "http://\(ip):\(server.port)/"
  }

  private func jpegData(from sampleBuffer: CMSampleBuffer) -> Data? {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
    let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
    guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else { return nil }
    return UIImage(cgImage: cgImage).jpegData(compressionQuality: 0.45)
  }

  private func localIPAddress() -> String? {
    var address: String?
    var ifaddrPointer: UnsafeMutablePointer<ifaddrs>?
    guard getifaddrs(&ifaddrPointer) == 0, let firstAddr = ifaddrPointer else { return nil }
    defer { freeifaddrs(ifaddrPointer) }

    for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
      let interface = ptr.pointee
      let family = interface.ifa_addr.pointee.sa_family
      if family == UInt8(AF_INET) {
        let name = String(cString: interface.ifa_name)
        if name == "en0" || name == "en1" {
          var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
          getnameinfo(
            interface.ifa_addr,
            socklen_t(interface.ifa_addr.pointee.sa_len),
            &hostname,
            socklen_t(hostname.count),
            nil,
            0,
            NI_NUMERICHOST
          )
          address = String(cString: hostname)
          if address != nil { break }
        }
      }
    }
    return address
  }
}

final class CastMirrorPlugin: NSObject, FlutterPlugin {
  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "com.casttotv.castscreenmirroring/mirror",
      binaryMessenger: registrar.messenger()
    )
    let instance = CastMirrorPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let manager = ScreenCaptureCoordinator.shared
    switch call.method {
    case "startWifiMirror":
      manager.startWifiMirror { mirrorResult in
        DispatchQueue.main.async {
          switch mirrorResult {
          case .success(let url):
            result(["success": true, "url": url])
          case .failure(let error):
            result(FlutterError(code: "MIRROR_ERROR", message: error.localizedDescription, details: nil))
          }
        }
      }
    case "stopWifiMirror":
      manager.stopWifiMirror()
      result(true)
    case "isWifiMirrorActive":
      result(manager.isWifiMirrorActive)
    case "isAirPlayMirrorActive":
      result(manager.isAirPlayMirrorActive())
    case "getWifiMirrorUrl":
      result(manager.mirrorURL())
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

enum CastMirrorPluginRegistrar {
  static func register(with registry: FlutterPluginRegistry) {
    guard let registrar = registry.registrar(forPlugin: "CastMirrorPlugin") else { return }
    CastMirrorPlugin.register(with: registrar)
  }
}
