import Cocoa

/// Keyboard Utils
///
/// You can import `Carbon.HIToolbox.Events` to use `kVK_` virtual keys
/// such as `CGKeyCode(kVK_ANSI_F)`
public struct Keyboard {
    /// Key down
    public static func down(key: CGKeyCode, with flags: CGEventFlags? = nil) {
        let keyDown = CGEvent(keyboardEventSource: nil, virtualKey: key, keyDown: true)
        if let flags = flags {
            keyDown?.flags.update(with: flags)
        }
        keyDown?.post(tap: .cghidEventTap)
    }

    /// Key up
    public static func up(key: CGKeyCode, with flags: CGEventFlags? = nil) {
        let keyUp = CGEvent(keyboardEventSource: nil, virtualKey: key, keyDown: false)
        if let flags = flags {
            keyUp?.flags.update(with: flags)
        }
        keyUp?.post(tap: .cghidEventTap)
    }

    /// Key press
    public static func press(key: CGKeyCode, with flags: CGEventFlags? = nil) {
        down(key: key, with: flags)
        up(key: key, with: flags)
    }
}
