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
        frame = CGRect(dictionaryRepresentation: info[kCGWindowBounds] as! CFDictionary)
    }
}

/// Window Utils
public struct Window {
    /// Get window list
    public static func list(pid: pid_t? = nil) -> [WindowInfo] {
        guard let windowInfo = CGWindowListCopyWindowInfo(.optionAll, kCGNullWindowID) else {
            return []
        }

        return NSArray(object: windowInfo)
                .compactMap {
                    $0 as? NSArray
                }
                .reduce([], +)
                .compactMap {
                    $0 as? NSDictionary
                }
                .filter { dict -> Bool in
                    pid == nil || (dict[kCGWindowOwnerPID] as! NSNumber).intValue == pid!
                }
                .map {
                    WindowInfo(info: $0)
                }
    }

    /// Get window detail
    public static func detail(of windowId: CGWindowID) -> WindowInfo? {
        guard let windowInfoList = CGWindowListCopyWindowInfo(.optionIncludingWindow, windowId) as NSArray?, windowInfoList.count > 0 else {
            return nil
        }
        return WindowInfo(info: windowInfoList.firstObject as! NSDictionary)
    }

    /// Take window screenshot
    public static func screenshot(with windowId: CGWindowID, options: CGWindowImageOption = [.boundsIgnoreFraming, .nominalResolution]) -> CGImage? {
        CGWindowListCreateImage(.null, .optionIncludingWindow, windowId, options)
    }
}
