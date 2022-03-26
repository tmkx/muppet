import Cocoa

/// Clipboard Utils
public struct Clipboard {
    /// Read clipboard text
    public static func readText() -> String? {
        NSPasteboard.general.string(forType: .string)
    }

    /// Write text to clipboard
    public static func writeText(_ text: String?) -> Bool {
        NSPasteboard.general.clearContents()
        if let text = text {
            return NSPasteboard.general.setString(text, forType: .string)
        } else {
            return true
        }
    }
}
