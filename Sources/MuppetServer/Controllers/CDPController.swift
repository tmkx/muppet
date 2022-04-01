import Cocoa
import Vapor
import Muppet
import SwiftyJSON

struct CDPController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let apps = routes.grouped("cdp")
        apps.webSocket(onUpgrade: entry)
    }

    func entry(_ req: Request, _ ws: WebSocket) {
        ws.onText { (socket: WebSocket, text: String) -> () in
            NSLog(text)
            let request = try! JSON(data: text.data(using: .utf8)!)
            let id = request["id"].intValue
            let message = request["method"].stringValue.split(separator: ".")
            guard id > 0, message.count == 2 else {
                return
            }
            let domain = message[0]
            let method = message[1]
            print(domain, method)
        }
    }
}
