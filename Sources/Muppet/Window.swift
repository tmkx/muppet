import Cocoa

public struct WindowInfo {
    public let windowAlpha: Double?
    public let isOnScreen: Bool?
    public let layer: UInt32?
    public let memoryUsage: UInt32?
    public let name: String?
    public let number: UInt32?
    public let ownerName: String?
    public let ownerPid: pid_t?
    public let sharingState: UInt32?
    public let storeType: UInt32?
    public let frame: CGRect?

    public init(info: NSDictionary) {
        windowAlpha = info[kCGWindowAlpha] as? Double
        isOnScreen = info[kCGWindowIsOnscreen] as? Bool
        layer = info[kCGWindowLayer] as? UInt32
        memoryUsage = info[kCGWindowMemoryUsage] as? UInt32
        name = info[kCGWindowName] as? String
        number = info[kCGWindowNumber] as? UInt32
        ownerName = info[kCGWindowOwnerName] as? String
        ownerPid = info[kCGWindowOwnerPID] as? pid_t
        sharingState = info[kCGWindowSharingState] as? UInt32
        storeType = info[kCGWindowStoreType] as? UInt32
        if let bounds = info[kCGWindowBounds] as? NSDictionary {
            let x = bounds["X"] as! Double;
            let y = bounds["Y"] as! Double;
            let width = bounds["Width"] as! Double;
            let height = bounds["Height"] as! Double;
            frame = CGRect(x: x, y: y, width: width, height: height)
        } else {
            frame = nil
        }
    }
}

/// Window Utils
public struct Window {
    /// Get window list
    public static func list(pid: pid_t? = nil) -> [WindowInfo] {
        let windowInfoList = CGWindowListCopyWindowInfo(.optionAll, kCGNullWindowID)! as NSArray

        var appWindows = [NSDictionary]()
        for _info in windowInfoList {
            let info = _info as! NSDictionary
            if pid == nil {
                appWindows.append(info)
            } else if (info[kCGWindowOwnerPID] as! NSNumber).intValue == pid! {
                appWindows.append(info)
            }
        }

        return appWindows.map({ WindowInfo(info: $0) })
    }

    /// Get window detail
    public static func detail(of windowId: CGWindowID) -> WindowInfo? {
        let windowInfoList = CGWindowListCopyWindowInfo(.optionIncludingWindow, windowId)! as NSArray

        for info in windowInfoList {
            return WindowInfo(info: info as! NSDictionary)
        }

        return nil
    }

    /// Take window screenshot
    public static func screenshot(with windowId: CGWindowID, options: CGWindowImageOption = [.boundsIgnoreFraming, .nominalResolution]) -> CGImage? {
        CGWindowListCreateImage(.null, .optionIncludingWindow, windowId, options)
    }
}
