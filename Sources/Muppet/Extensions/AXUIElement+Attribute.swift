import Cocoa

extension AXUIElement {
    /// The close button of the window represented by this accessibility object.
    public func closeButton() -> AXUIElement? {
        getElement(of: kAXCloseButtonAttribute)
    }

    /// The minimize button of the window represented by this accessibility object.
    public func minimizeButton() -> AXUIElement? {
        getElement(of: kAXMinimizeButtonAttribute)
    }

    public func fullScreenButton() -> AXUIElement? {
        getElement(of: kAXFullScreenButtonAttribute)
    }

    /// The zoom button of the window represented by this accessibility object.
    public func zoomButton() -> AXUIElement? {
        getElement(of: kAXZoomButtonAttribute)
    }

    /// This accessibility object’s parent object in the accessibility hierarchy.
    public func parent() -> AXUIElement? {
        getElement(of: kAXParentAttribute)
    }

    /// An array of the first-order accessibility objects contained by this accessibility object.
    public func children() -> [AXUIElement]? {
        getElements(of: kAXChildrenAttribute)
    }

    /// An array of selected first-order accessibility objects contained by this accessibility object.
    public func selectedChildren() -> [AXUIElement]? {
        getElements(of: kAXSelectedChildrenAttribute)
    }

    /// An array of first-order accessibility objects contained by this accessibility object that are visible to a sighted user.
    public func visibleChildren() -> [AXUIElement]? {
        getElements(of: kAXVisibleChildrenAttribute)
    }

    /// The accessibility object representing the menu bar of this application.
    public func menuBar() -> AXUIElement? {
        getElement(of: kAXMenuBarAttribute)
    }

    /// The title associated with this accessibility object.
    public func title() -> String? {
        attributeValue(for: kAXTitleAttribute) as? String
    }

    public func setTitle(with title: String) -> Bool? {
        set(for: kAXTitleAttribute, with: title)
    }

    /// The global screen coordinates of the top-left corner of this accessibility object.
    public func position() -> CGPoint? {
        (attributeValue(for: kAXPositionAttribute) as! AXValue?)?.cgPoint()
    }

    public func setPosition(to position: CGPoint) -> Bool {
        set(for: kAXPositionAttribute, with: position)
    }

    /// The vertical and horizontal dimensions of this accessibility object.
    public func size() -> CGSize? {
        (attributeValue(for: kAXSizeAttribute) as! AXValue?)?.cgSize()
    }

    public func setSize(to size: CGSize) -> Bool {
        set(for: kAXSizeAttribute, with: size)
    }

    public func frame() -> CGRect? {
        guard let origin = position(), let size = size() else {
            return nil
        }
        return CGRect(origin: origin, size: size)
    }

    public func setFrame(to frame: CGRect) -> Bool {
        let position = frame.origin
        let size = frame.size
        return setSize(to: size) && setPosition(to: position)
    }

    /// Indicates whether the window represented by this accessibility object is currently minimized in the Dock.
    public func isMinimized() -> Bool? {
        attributeValue(for: kAXMinimizedAttribute) as? Bool
    }

    /// Indicates whether the window represented by this accessibility object is currently minimized in the Dock.
    public func minimize(_ whether: Bool = true) -> Bool? {
        set(for: kAXMinimizedAttribute, with: whether)
    }

    public func isFullScreen() -> Bool? {
        attributeValue(for: kAXFullscreenAttribute) as? Bool
    }

    public func fullScreen(_ whether: Bool = true) -> Bool? {
        set(for: kAXFullscreenAttribute, with: whether)
    }

    /// The role, or type, of this accessibility object (for example, AXButton).
    public func role() -> String? {
        attributeValue(for: kAXRoleAttribute) as? String
    }

    /// The subrole of this accessibility object (for example, AXCloseButton).
    public func subrole() -> String? {
        attributeValue(for: kAXSubroleAttribute) as? String
    }

    /// A localized string describing the role (for example, “button”).
    /// This string must be readable by (or speakable to) the user.
    public func roleDescription() -> String? {
        attributeValue(for: kAXRoleDescriptionAttribute) as? String
    }

    /// A localized string containing help text for this accessibility object.
    /// An accessibility object that provides help information should include this attribute.
    public func help() -> String? {
        attributeValue(for: kAXHelpAttribute) as? String
    }

    /// The value associated with this accessibility object (for example, a scroller value).
    public func value() -> Any? {
        attributeValue(for: kAXValueAttribute)
    }

    /// Used to supplement kAXValueAttribute.
    public func valueDescription() -> String? {
        attributeValue(for: kAXValueDescriptionAttribute) as? String
    }

    /// Indicates whether the window represented by this accessibility object is modal.
    /// This attribute is recommended for all accessibility objects that represent windows.
    public func isModal() -> Bool? {
        attributeValue(for: kAXModalAttribute) as? Bool
    }
}
