import Cocoa
import SwiftyJSON
import Muppet

public struct MouseEvent {
    public let button: MouseEventButton?
    public let clickCount: UInt?
    public let type: MouseEventType?
    public let modifiers: UInt?
    public let x: Int?
    public let y: Int?
    public let deltaX: Double?
    public let deltaY: Double?

    init(params: JSON) {
        button = MouseEventButton(rawValue: params["button"].string!)
        clickCount = params["clickCount"].uInt
        type = MouseEventType(rawValue: params["type"].string!)
        modifiers = params["modifiers"].uInt
        x = params["x"].int
        y = params["y"].int
        deltaX = params["deltaX"].double
        deltaY = params["deltaY"].double
    }
}

public struct CDPInput {
    public static func emulateTouchFromMouseEvent(to windowId: CGWindowID, with event: MouseEvent) {
        guard
                let window = Muppet.Window.detail(of: windowId),
                let ownerPid = window.ownerPid,
                let point = window.frame?.origin.applying(CGAffineTransform(translationX: CGFloat(event.x!), y: CGFloat(event.y!)))
        else { return }

        switch event.type {
        case .mousePressed, .mouseReleased:
            guard let application = Muppet.Application.getApp(pid: ownerPid) else { return }
            if !application.isActive {
                application.activate(options: .activateIgnoringOtherApps)
            }
            if event.type == .mousePressed {
                Muppet.Mouse.down(at: point, using: event.button?.cgButton ?? .left)
            } else if event.type == .mouseReleased {
                Muppet.Mouse.up(at: point, using: event.button?.cgButton ?? .left)
            }
            break
        default:
            break
        }
    }
}

public enum MouseEventButton: String {
    case left = "left"
    case right = "right"
    case none = "none"

    var cgButton: CGMouseButton {
        switch self {
        case .left:
            return .left
        case .right:
            return .right
        case .none:
            return .center
        }
    }
}

public enum MouseEventType: String {
    case mousePressed = "mousePressed"
    case mouseReleased = "mouseReleased"
    case mouseMoved = "mouseMoved"
    case mouseWheel = "mouseWheel"
}
