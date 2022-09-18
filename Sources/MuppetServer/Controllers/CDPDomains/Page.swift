import Cocoa
import Vapor
import Muppet
import NIO
import SwiftyJSON

public struct CDPPage {
    public static func startScreencast(_ socket: WebSocket, windowId: CGWindowID) -> RepeatedTask {
        socket.eventLoop.scheduleRepeatedTask(initialDelay: .zero, delay: .milliseconds(500)) { task in
            if let screencastFrame = screencast(of: windowId) {
                socket.send(screencastFrame)
            }
        }
    }

    static func screencast(of windowId: CGWindowID) -> String? {
        if let window = Muppet.Window.detail(of: windowId), let jpegData = Muppet.Window.screenshot(with: windowId)?.jpegData() {
            let jsonData = [
                "method": "Page.screencastFrame",
                "params": [
                    "sessionId": 1,
                    "data": jpegData.base64EncodedString(),
                    "metadata": [
                        "offsetTop": 0,
                        "scrollOffsetX": 0,
                        "scrollOffsetY": 0,
                        "pageScaleFactor": 1,
                        "deviceWidth": (window.frame?.width ?? 0) as Any,
                        "deviceHeight": (window.frame?.height ?? 0) as Any,
                        "timestamp": Date().timeIntervalSince1970,
                    ]
                ],
            ] as [String: Any]

            return JSON(jsonData).rawString(.utf8, options: .init(rawValue: 0))
        }
        return nil
    }
}
