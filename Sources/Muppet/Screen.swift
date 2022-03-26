import Cocoa

public struct Display {
    public let id: CGDirectDisplayID
    public let isMain: Bool
    public let isActive: Bool
    public let isAsleep: Bool
    public let isBuiltin: Bool
    public let isOnline: Bool
    public let isStereo: Bool
    public let isInMirrorSet: Bool
    public let isAlwaysInMirrorSet: Bool
    public let isInHWMirrorSet: Bool
    public let serialNumber: UInt32
    public let modelNumber: UInt32
    public let displayMode: CGDisplayMode?
}

public struct IODisplay {
    let productName: NSObject?
    let serialNumber: NSNumber?
    let productID: NSNumber?
    let vendorID: NSNumber?
    let yearManufacture: NSNumber?
    let weekManufacture: NSNumber?
}

/// Screen Utils
public struct Screen {
    /// Get screen list
    public static func getScreens() -> [NSScreen] {
        NSScreen.screens
    }

    /// Get display list
    public static func getDisplays() -> [Display] {
        var displayCount: UInt32 = 0
        CGGetActiveDisplayList(0, nil, &displayCount)
        let activeDisplays = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: Int(displayCount))
        CGGetActiveDisplayList(displayCount, activeDisplays, &displayCount)
        return Array(0..<Int(displayCount)).map { i -> Display in
            let displayID = activeDisplays[i]
            return Display(
                id: displayID,
                isMain: CGDisplayIsMain(displayID) > 0,
                isActive: CGDisplayIsActive(displayID) > 0,
                isAsleep: CGDisplayIsAsleep(displayID) > 0,
                isBuiltin: CGDisplayIsBuiltin(displayID) > 0,
                isOnline: CGDisplayIsOnline(displayID) > 0,
                isStereo: CGDisplayIsStereo(displayID) > 0,
                isInMirrorSet: CGDisplayIsInMirrorSet(displayID) > 0,
                isAlwaysInMirrorSet: CGDisplayIsAlwaysInMirrorSet(displayID) > 0,
                isInHWMirrorSet: CGDisplayIsInHWMirrorSet(displayID) > 0,
                serialNumber: CGDisplaySerialNumber(displayID),
                modelNumber: CGDisplayModelNumber(displayID),
                displayMode: CGDisplayCopyDisplayMode(displayID)
            )
        }
    }

    /// Get IODisplay list
    public static func getIODisplays() -> [IODisplay] {
        var iter: io_iterator_t = 0

        guard let matching = IOServiceMatching("IODisplayConnect") else {
            return []
        }
        guard  (IOServiceGetMatchingServices(kIOMasterPortDefault, matching, &iter) == 0) else {
            return []
        }

        var ioDisplays: [IODisplay] = Array()

        while case let serv = IOIteratorNext(iter), serv != 0 {
            let displayInfo = IODisplayCreateInfoDictionary(serv, IOOptionBits(kIODisplayOnlyPreferredName)).takeRetainedValue()
            var productName: NSObject? = nil
            var serialNumber: NSNumber? = nil
            var productID: NSNumber? = nil
            var vendorID: NSNumber? = nil
            var yearManufacture: NSNumber? = nil
            var weekManufacture: NSNumber? = nil
            if let p = CFDictionaryGetValue(displayInfo, Unmanaged.passRetained("DisplayProductName" as NSString).autorelease().toOpaque()) {
                productName = Unmanaged<NSObject>.fromOpaque(p).takeUnretainedValue()
            }
            if let p = CFDictionaryGetValue(displayInfo, Unmanaged.passRetained("DisplaySerialNumber" as NSString).autorelease().toOpaque()) {
                serialNumber = Unmanaged<NSNumber>.fromOpaque(p).takeUnretainedValue()
            }
            if let p = CFDictionaryGetValue(displayInfo, Unmanaged.passRetained("DisplayProductID" as NSString).autorelease().toOpaque()) {
                productID = Unmanaged<NSNumber>.fromOpaque(p).takeUnretainedValue()
            }
            if let p = CFDictionaryGetValue(displayInfo, Unmanaged.passRetained("DisplayVendorID" as NSString).autorelease().toOpaque()) {
                vendorID = Unmanaged<NSNumber>.fromOpaque(p).takeUnretainedValue()
            }
            if let p = CFDictionaryGetValue(displayInfo, Unmanaged.passRetained("DisplayYearManufacture" as NSString).autorelease().toOpaque()) {
                yearManufacture = Unmanaged<NSNumber>.fromOpaque(p).takeUnretainedValue()
            }
            if let p = CFDictionaryGetValue(displayInfo, Unmanaged.passRetained("DisplayWeekManufacture" as NSString).autorelease().toOpaque()) {
                weekManufacture = Unmanaged<NSNumber>.fromOpaque(p).takeUnretainedValue()
            }
            ioDisplays.append(IODisplay(
                productName: productName,
                serialNumber: serialNumber,
                productID: productID,
                vendorID: vendorID,
                yearManufacture: yearManufacture,
                weekManufacture: weekManufacture
            ))
        }
        IOObjectRelease(iter)

        return ioDisplays
    }

    public static func screenshot(to savePath: String, preferredDisplayID: Int = 0) throws {
        let displayID = preferredDisplayID != 0 ? CGDirectDisplayID(preferredDisplayID) : CGMainDisplayID()

        let imageRef = CGDisplayCreateImage(displayID)
        let imageRep = NSBitmapImageRep(cgImage: imageRef!)
        if let data = imageRep.representation(using: .png, properties: [:]) {
            let dest = URL(fileURLWithPath: savePath)
            try data.write(to: dest)
        }
    }
}
