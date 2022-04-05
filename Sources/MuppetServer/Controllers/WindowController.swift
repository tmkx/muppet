import Cocoa
import Vapor
import Muppet

struct SerializableWindowInfo: Content {
    let windowAlpha: Double?
    let isOnScreen: Bool?
    let layer: UInt32?
    let memoryUsage: UInt32?
    let name: String?
    let number: UInt32?
    let ownerName: String?
    let ownerPid: pid_t?
    let sharingState: UInt32?
    let storeType: UInt32?
    let frame: CGRect?

    init(origin: WindowInfo) {
        windowAlpha = origin.windowAlpha
        isOnScreen = origin.isOnScreen
        layer = origin.layer
        memoryUsage = origin.memoryUsage
        name = origin.name
        number = origin.number
        ownerName = origin.ownerName
        ownerPid = origin.ownerPid
        sharingState = origin.sharingState
        storeType = origin.storeType
        frame = origin.frame
    }
}

struct WindowController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let apps = routes.grouped("windows")
        apps.get(use: list)
        apps.get(":windowId", use: detail)
        apps.get("screenshot", ":windowId", use: screenshot)
    }

    func list(_ req: Request) throws -> [SerializableWindowInfo] {
        let pid = try? req.query.get(Int32.self, at: "pid")
        return Muppet.Window.list(pid: pid).map(({ SerializableWindowInfo(origin: $0) }))
    }

    func detail(_ req: Request) throws -> SerializableWindowInfo {
        let windowId = req.parameters.get("windowId", as: CGWindowID.self)!
        if let window = Muppet.Window.detail(of: windowId) {
            return SerializableWindowInfo(origin: window)
        } else {
            throw Abort(.notFound)
        }
    }

    func screenshot(_ req: Request) throws -> Response {
        let windowId = req.parameters.get("windowId", as: CGWindowID.self)!
        guard let pngData = Muppet.Window.screenshot(with: windowId)?.pngData() else {
            return Response(status: .notFound, body: .empty)
        }
        var headers = HTTPHeaders()
        headers.add(name: .contentType, value: "image/png")
        return Response(headers: headers, body: Response.Body(data: pngData))
    }
}
