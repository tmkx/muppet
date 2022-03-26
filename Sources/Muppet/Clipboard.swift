import Cocoa

/// Clipboard Utils
public struct Clipboard {
    /// Clear clipboard
    public static func clear() {
        NSPasteboard.general.clearContents()
    }

    /// Read clipboard text
    public static func readText() -> String? {
        NSPasteboard.general.string(forType: .string)
    }

    /// Write text to clipboard
    public static func write(text: String) -> Bool {
        clear()
        return NSPasteboard.general.setString(text, forType: .string)
    }

    /// Whether clipboard is empty
    public static func isEmpty() -> Bool {
        if let count = NSPasteboard.general.pasteboardItems?.count {
            return count == 0
        } else {
            return true
        }
    }
}
