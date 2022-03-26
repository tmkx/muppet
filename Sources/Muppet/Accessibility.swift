import Cocoa

/// Accessibility Utils
public struct Accessibility {
    public static let safeAttributes = [
        "AXChildren", "AXFocused", "AXMinimized", "AXFullScreen", "AXTitle", "AXHidden",
        "AXRole", "AXRoleDescription", "AXEnabled", "AXMain", "AXModal", "AXEdited", "AXSelected",
        "AXFrontmost", "AXEnhancedUserInterface", "AXInsertionPointLineNumber", "AXNumberOfCharacters",
        "AXMenuItemCmdModifiers", "AXMenuItemCmdVirtualKey", "AXMenuItemCmdGlyph", "AXDescription",
        "AXValue", "AXSubrole", "AXSelectedText", "AXHelp", "AXMenuItemCmdChar", "AXIdentifier",
        "AXPosition", "AXSize", "AXFrame", "AXActivationPoint"
    ]

    public static func getAXElementByPid(_ pid: Int32) -> AXUIElement {
        AXUIElementCreateApplication(pid)
    }

    public static func getElementAttributeNames(_ element: AXUIElement) -> [String] {
        var cfArray: CFArray?
        if AXUIElementCopyAttributeNames(element, &cfArray) == .success {
            return cfArray as! [String]
        } else {
            return []
        }
    }

    public static func getElementActions(_ element: AXUIElement) -> [String: String] {
        var actionNames: CFArray?
        AXUIElementCopyActionNames(element, &actionNames)
        return Dictionary(uniqueKeysWithValues: (actionNames as? [String] ?? []).map { action -> (String, String) in
            var description: CFString?
            AXUIElementCopyActionDescription(element, action as CFString, &description)
            return (action, description as String? ?? "")
        })
    }

    public static func getElementAttributes(_ element: AXUIElement) -> [String: Any?] {
        var attributes = Dictionary(uniqueKeysWithValues: getElementAttributeNames(element).map { attr -> (String, Any?) in
            (attr, getAttributeValue(element, attr))
        })

        attributes["Actions"] = getElementActions(element)

        return attributes
    }

    public static func getAttributeValue(_ element: AXUIElement, _ attribute: String) -> Any? {
        var cfType: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, attribute as CFString, &cfType) == .success, cfType != nil else {
            return nil
        }

        if !safeAttributes.contains(attribute) {
            return "(Unsupported Attr, \(CFGetTypeID(cfType!)))"
        }

        switch CFGetTypeID(cfType!) {
        case AXUIElementGetTypeID():
            return getElementAttributes(cfType as! AXUIElement)
        case CFArrayGetTypeID():
            return (cfType as! [Any]).map { item -> Any in
                if CFGetTypeID(item as CFTypeRef) == AXUIElementGetTypeID() {
                    return getElementAttributes(item as! AXUIElement)
                } else {
                    return item
                }
            }
        default:
            return normalizeType(cfType!)
        }
    }

    public static func traverseElementTree(_ element: AXUIElement, _ continue: (_ elem: AXUIElement) -> Bool) -> Bool {
        var cfType: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, "AXChildren" as CFString, &cfType) == .success, cfType != nil, CFGetTypeID(cfType!) == CFArrayGetTypeID() else {
            return false
        }
        let array = (cfType as! [AXUIElement])
        for elem in array {
            if !`continue`(elem) {
                return true
            }
            if traverseElementTree(elem, `continue`) {
                return true
            }
        }
        return false
    }

    public static func normalizeType(_ cfTypeRef: CFTypeRef) -> Any? {
        switch CFGetTypeID(cfTypeRef) {
        case CFStringGetTypeID():
            return cfTypeRef as! String
        case CFNumberGetTypeID():
            return cfTypeRef as! CFNumber
        case CFBooleanGetTypeID():
            return cfTypeRef as! Bool
        case AXValueGetTypeID():
            let value = cfTypeRef as! AXValue
            switch AXValueGetType(value) {
            case .illegal:
                return nil
            case .cgPoint:
                var point = CGPoint.zero
                AXValueGetValue(value, .cgPoint, &point);
                return ["x": point.x, "y": point.y]
            case .cgSize:
                var size = CGSize.zero
                AXValueGetValue(value, .cgSize, &size);
                return ["width": size.width, "height": size.height]
            default:
                return nil
            }
        default:
            print(CFGetTypeID(cfTypeRef), cfTypeRef)
            return nil
        }
    }
}
