import Cocoa

extension AXValue {
    public func type() -> AXValueType {
        AXValueGetType(self)
    }

    public static func new(value: inout Any) -> AXValue? {
        if value is CGPoint {
            return AXValueCreate(.cgPoint, &value)
        } else if value is CGSize {
            return AXValueCreate(.cgSize, &value)
        } else if value is CGRect {
            return AXValueCreate(.cgRect, &value)
        } else if value is CFRange {
            return AXValueCreate(.cfRange, &value)
        } else if value is AXError {
            return AXValueCreate(.axError, &value)
        }
        return nil
    }

    public func cgPoint() -> CGPoint? {
        var value: CGPoint = CGPoint.zero
        guard AXValueGetValue(self, .cgPoint, &value) else {
            return nil
        }
        return value
    }

    public func cgSize() -> CGSize? {
        var value: CGSize = CGSize.zero
        guard AXValueGetValue(self, .cgSize, &value) else {
            return nil
        }
        return value
    }

    public func cfRange() -> CFRange? {
        var value: CFRange = CFRange()
        guard AXValueGetValue(self, .cfRange, &value) else {
            return nil
        }
        return value
    }
}
