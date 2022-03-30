import Vapor
import SwiftyJSON

let app = try Application(.detect())
defer {
    app.shutdown()
}

app.webSocket("cdp") { (req: Request, ws: WebSocket) -> () in
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

try configure(app)
try app.run()
