import Cocoa
import SwiftyJSON
import Muppet

public struct NodeHierarchy: Codable {
    let nodeName: String
    let localName: String
    let nodeType: Int
    let attributes: [String]
    let childNodeCount: Int
    let children: [NodeHierarchy]
}

public struct CDPDom {
    public static func getDocumentHierarchy(of element: AXUIElement) -> NodeHierarchy? {
        let title = element.title() ?? "Unknown"
        let role = element.role() ?? "Unknown"
        let roleDescription = element.roleDescription() ?? "Unknown"
        let actions = element.actionsNames() ?? []

        var children: [NodeHierarchy] = []
        for child in (element.children() ?? []) {
            if let childHierarchy = getDocumentHierarchy(of: child) {
                children.append(childHierarchy)
            }
        }

        return NodeHierarchy(
            nodeName: role,
            localName: role,
            nodeType: 1,
            attributes: ["title", title, "description", roleDescription, "actions", actions.joined(separator: ", ")],
            childNodeCount:
            children.count,
            children: children
        )
    }

    public static func getDocument(of windowId: CGWindowID) throws -> JSON? {
        let window = Muppet.Window.detail(of: windowId)
        guard let pid = window?.ownerPid else {
            return nil
        }
        let root = Muppet.Accessibility.getAXElementByPid(pid)
        if let hierarchy = CDPDom.getDocumentHierarchy(of: root) {
            let jsonData = try JSONEncoder().encode(hierarchy)
            let json = try JSON(data: jsonData)
            return JSON([
                "root": json
            ])
        }
        return nil
    }
}
