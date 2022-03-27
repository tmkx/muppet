import Cocoa

extension AXUIElement {
    /// Simulates a single click, such as on a button.
    public func press() -> Bool {
        action(for: kAXPressAction)
    }

    /// Simulates pressing a Cancel button.
    public func cancel() -> Bool {
        action(for: kAXCancelAction)
    }

    /// Simulates pressing the Return key.
    public func confirm() -> Bool {
        action(for: kAXConfirmAction)
    }

    /// Decrements the value of the accessibility object.
    /// The amount the value is decremented by is determined by the value of the kAXValueIncrementAttribute attribute.
    public func decrement() -> Bool {
        action(for: kAXDecrementAction)
    }

    /// Increments the value of the accessibility object.
    /// The amount the value is incremented by is determined by the value of the kAXValueIncrementAttribute attribute.
    public func increment() -> Bool {
        action(for: kAXIncrementAction)
    }

    /// Select the UIElement, such as a menu item.
    public func pick() -> Bool {
        action(for: kAXPickAction)
    }

    /// Causes a window to become as frontmost as is allowed by the containing application’s circumstances.
    /// Note that an application’s floating windows (such as inspector windows) might remain above a window that performs the raise action.
    public func raise() -> Bool {
        action(for: kAXRaiseAction)
    }

    /// Simulates the opening of a contextual menu in the element represented by this accessibility object.
    /// This action can also be used to simulate the display of a menu that is preassociated with an element,
    /// such as the menu that displays when a user clicks Safari’s back button slowly.
    public func showMenu() -> Bool {
        action(for: kAXShowMenuAction)
    }

    /// Show alternate or hidden UI.
    /// This is often used to trigger the same change that would occur on a mouse hover.
    public func showAlternateUI() -> Bool {
        action(for: kAXShowAlternateUIAction)
    }

    /// Show default UI.
    /// This is often used to trigger the same change that would occur when a mouse hover ends.
    public func showDefaultUI() -> Bool {
        action(for: kAXShowDefaultUIAction)
    }
}
