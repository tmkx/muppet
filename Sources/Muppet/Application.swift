import Cocoa

/// Application Utils
public struct Application {
    public static func getRunningApps() -> [NSRunningApplication] {
        NSWorkspace.shared.runningApplications
    }

    public static func getApps(bundleIdentifier: String) -> [NSRunningApplication] {
        NSRunningApplication.runningApplications(withBundleIdentifier: bundleIdentifier)
    }

    public static func getApps(pid: pid_t) -> NSRunningApplication? {
        NSRunningApplication(processIdentifier: pid)
    }
}
