import Cocoa

public let kAXFullscreenAttribute = "AXFullScreen"
public let kAXEnhancedUserInterfaceAttribute = "AXEnhancedUserInterface"
public let kAXFrameAttribute = "AXFrame"
public let kAXActivationPointAttribute = "AXActivationPoint"

extension AXUIElement {
    /// Returns the value of an accessibility object's attribute.
    public func attributeValue(for attribute: String) -> Any? {
        var value: CFTypeRef?
        guard AXUIElementCopyAttributeValue(self, attribute as CFString, &value) == .success else {
            return nil
        }
        return value
    }

    /// Returns an array of attribute values for the accessibility object's attribute, starting at the specified index.
    public func attributeValues(for attribute: String, index: Int, maxValues: Int) -> [Any?]? {
        var values: CFArray?
        guard AXUIElementCopyAttributeValues(self, attribute as CFString, index, maxValues, &values) == .success else {
            return nil
        }
        return values as? [AnyObject]
    }

    /// Returns the count of the array of an accessibility object's attribute value.
    public func valuesCount(for attribute: String) -> Int {
        var count: CFIndex = 0
        AXUIElementGetAttributeValueCount(self, attribute as CFString, &count)
        return count as Int
    }

    /// Returns a list of all the attributes supported by the specified accessibility object.
    public func attributeNames() -> [String]? {
        var names: CFArray?
        guard AXUIElementCopyAttributeNames(self, &names) == .success else {
            return nil
        }
        return names as? [String]
    }

    /// Returns a list of all the actions the specified accessibility object can perform.
    public func actionsNames() -> [String]? {
        var names: CFArray?
        guard AXUIElementCopyActionNames(self, &names) == .success else {
            return nil
        }
        return names as? [String]
    }

    /// Returns a localized description of the specified accessibility object's action.
    public func actionDescription(for key: String) -> String? {
        var desc: CFString?
        guard AXUIElementCopyActionDescription(self, key as CFString, &desc) == .success else {
            return nil
        }
        return desc as? String;
    }

    /// Requests that the specified accessibility object perform the specified action.
    public func action(for key: String) -> Bool {
        let axError = AXUIElementPerformAction(self, key as CFString)
        return axError == .success
    }

    /// Returns whether the specified accessibility object's attribute can be modified.
    public func isAttributeSettable(for key: String) -> Bool {
        var settable: DarwinBoolean = false
        AXUIElementIsAttributeSettable(self, key as CFString, &settable)
        return settable.boolValue
    }

    /// Sets the accessibility object's attribute to the specified value.
    public func set(for key: String, with value: Any) -> Bool {
        var val = value
        let result = (AXValue.new(value: &val) ?? val) as AnyObject
        let error = AXUIElementSetAttributeValue(self, key as CFString, result)
        return error == .success
    }

    public func getElement(of key: String) -> AXUIElement? {
        guard let value = attributeValue(for: key) as CFTypeRef?, CFGetTypeID(value) == AXUIElementGetTypeID() else {
            return nil
        }
        return (value as! AXUIElement)
    }

    /// Returns the accessibility object at the specified position in top-left relative screen coordinates.
    public func getElement(at position: CGPoint) -> AXUIElement? {
        var element: AXUIElement? = nil
        let axError = AXUIElementCopyElementAtPosition(self, Float(position.x), Float(position.y), &element)
        print(axError.rawValue)
        return element
    }

    public func getElements(of key: String) -> [AXUIElement]? {
        let count = valuesCount(for: key)
        guard let value = attributeValues(for: key, index: 0, maxValues: count) as CFTypeRef?, CFGetTypeID(value) == CFArrayGetTypeID() else {
            return nil
        }
        return (value as! [AXUIElement])
    }
}
