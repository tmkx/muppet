import Cocoa

/// Mouse Utils
///
/// You can get mouse position by pressing `⌘ + ⇧ + 4`
public struct Mouse {
    /// Get mouse position
    public static func getPosition() -> CGPoint {
        if let location = CGEvent(source: nil)?.location {
            return location
        } else {
            return CGPoint.zero
        }
    }

    /// Move mouse
    public static func moveTo(point: CGPoint) {
        let eventMove = CGEvent(mouseEventSource: nil, mouseType: .mouseMoved, mouseCursorPosition: point, mouseButton: .left)
        eventMove?.post(tap: .cghidEventTap)
    }

    /// Get button type. (down, up, dragged)
    static func getButtonType(_ button: CGMouseButton) -> (CGEventType, CGEventType, CGEventType) {
        switch button {
        case .right:
            return (.rightMouseDown, .rightMouseUp, .rightMouseDragged)
        case .center:
            return (.otherMouseDown, .otherMouseUp, .otherMouseDragged)
        default:
            return (.leftMouseDown, .leftMouseUp, .leftMouseDragged)
        }
    }

    public static func down(at point: CGPoint, using button: CGMouseButton = .left) {
        let (mouseDownType, _, _) = getButtonType(button)
        let eventDown = CGEvent(mouseEventSource: nil, mouseType: mouseDownType, mouseCursorPosition: point, mouseButton: button)
        eventDown?.post(tap: .cghidEventTap)
    }

    public static func up(at point: CGPoint, using button: CGMouseButton = .left) {
        let (_, mouseUpType, _) = getButtonType(button)
        let eventUp = CGEvent(mouseEventSource: nil, mouseType: mouseUpType, mouseCursorPosition: point, mouseButton: button)
        eventUp?.post(tap: .cghidEventTap)
    }

    /// Click
    public static func click(at point: CGPoint, using button: CGMouseButton = .left) {
        down(at: point, using: button)
        usleep(10_000)
        up(at: point, using: button)
    }

    /// Double Click
    public static func dbclick(at point: CGPoint, using button: CGMouseButton = .left) {
        let (mouseDownType, mouseUpType, _) = getButtonType(button)

        let downEvent = CGEvent(mouseEventSource: nil, mouseType: mouseDownType, mouseCursorPosition: point, mouseButton: button)
        let upEvent = CGEvent(mouseEventSource: nil, mouseType: mouseUpType, mouseCursorPosition: point, mouseButton: button)

        downEvent?.setIntegerValueField(.mouseEventClickState, value: 1)
        downEvent?.post(tap: .cghidEventTap)
        upEvent?.setIntegerValueField(.mouseEventClickState, value: 1)
        upEvent?.post(tap: .cghidEventTap)

        downEvent?.setIntegerValueField(.mouseEventClickState, value: 2)
        downEvent?.post(tap: .cghidEventTap)
        upEvent?.setIntegerValueField(.mouseEventClickState, value: 2)
        upEvent?.post(tap: .cghidEventTap)
    }

    /// Drag
    public static func drag(from: CGPoint, to: CGPoint, using button: CGMouseButton = .left) {
        let (mouseDownType, mouseUpType, mouseDragType) = getButtonType(button)

        let downEvent = CGEvent(mouseEventSource: nil, mouseType: mouseDownType, mouseCursorPosition: from, mouseButton: button)
        let dragEvent = CGEvent(mouseEventSource: nil, mouseType: mouseDragType, mouseCursorPosition: to, mouseButton: button)
        let upEvent = CGEvent(mouseEventSource: nil, mouseType: mouseUpType, mouseCursorPosition: to, mouseButton: button)

        downEvent?.post(tap: .cghidEventTap)
        usleep(100_000)
        dragEvent?.post(tap: .cghidEventTap)
        usleep(100_000)
        upEvent?.post(tap: .cghidEventTap)
    }
}
