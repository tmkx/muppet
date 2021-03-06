import Cocoa
import SwiftyJSON
import Muppet

public struct MouseEvent {
    // "left" | "right" | "none"
    public let button: String?
    public let clickCount: UInt?
    // "mousePressed" | "mouseReleased" | "mouseMoved" | "mouseWheel"
    public let type: String?
    public let modifiers: UInt?
    public let x: Int?
    public let y: Int?
    public let deltaX: Double?
    public let deltaY: Double?

    init(params: JSON) {
        button = params["button"].string
        clickCount = params["clickCount"].uInt
        type = params["type"].string
        modifiers = params["modifiers"].uInt
        x = params["x"].int
        y = params["y"].int
        deltaX = params["deltaX"].double
        deltaY = params["deltaY"].double
    }
}

public struct CDPInput {
    public static func emulateTouchFromMouseEvent(to windowId: CGWindowID, with event: MouseEvent) {
        let window = Muppet.Window.detail(of: windowId)
        let point = window?.frame?.origin.applying(CGAffineTransform(translationX: CGFloat(event.x!), y: CGFloat(event.y!)))

        switch event.type {
        case "mousePressed", "mouseReleased":
            if let point = point, let ownerPid = window?.ownerPid {
                Muppet.Application.getApps(pid: ownerPid)?.activate(options: .activateIgnoringOtherApps)
                if event.type == "mousePressed" {
                    Muppet.Mouse.down(at: point, using: .left)
                } else if event.type == "mouseReleased" {
                    Muppet.Mouse.up(at: point, using: .left)
                }
            }
            break
        default:
            break
        }
    }
}
