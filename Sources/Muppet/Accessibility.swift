import Cocoa

/// Accessibility Utils
public struct Accessibility {
    public static func isPermissionGranted() -> Bool {
        AXIsProcessTrusted()
    }

    public static func requestPermission() -> Bool {
        AXIsProcessTrustedWithOptions([kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true] as CFDictionary)
    }

    public static func getAXElementByPid(_ pid: Int32) -> AXUIElement {
        AXUIElementCreateApplication(pid)
    }
}
