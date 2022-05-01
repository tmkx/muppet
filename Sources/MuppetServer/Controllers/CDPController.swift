import Cocoa
import Vapor
import NIO
import SwiftyJSON

struct CDPController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let apps = routes.grouped("cdp")
        apps.webSocket(":windowId", onUpgrade: entry)
    }

    func entry(_ req: Request, _ ws: WebSocket) {
        let windowId = req.parameters.get("windowId", as: CGWindowID.self)!

        var screencastTask: RepeatedTask?

        ws.onClose.whenComplete { result in
            screencastTask?.cancel()
            screencastTask = nil
        }

        ws.onText { (socket: WebSocket, text: String) -> () in
            if (!text.contains("Page.screencastFrameAck")) {
                NSLog(text)
            }
            let request = try! JSON(data: text.data(using: .utf8)!)
            let id = request["id"].intValue
            let message = request["method"].stringValue.split(separator: ".")
            guard id > 0, message.count == 2 else {
                return
            }
            let domain = message[0]
            let method = message[1]

            switch domain {
            case "Page":
                if method == "startScreencast" {
                    screencastTask?.cancel()
                    screencastTask = CDPPage.startScreencast(socket, windowId: windowId)
                } else if method == "stopScreencast" {
                    screencastTask?.cancel()
                    screencastTask = nil
                }
            case "Input":
                if method == "emulateTouchFromMouseEvent" {
                    CDPInput.emulateTouchFromMouseEvent(to: windowId, with: .init(params: request["params"]))
                }
                break
            default:
                break
            }

            let jsonData = ["id": id, "result": [:], ] as [String: Any]
            if let jsonText = JSON(jsonData).rawString(.utf8, options: .init(rawValue: 0)) {
                socket.send(jsonText)
            }
        }
    }
}
