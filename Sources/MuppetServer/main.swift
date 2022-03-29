import Vapor

let app = try Application(.detect())
defer {
    app.shutdown()
}

app.webSocket("cdp") { (req: Request, ws: WebSocket) -> () in
    ws.onText { (socket: WebSocket, text: String) -> () in
        print(text)
        socket.send(text)
    }
}

try app.run()
