import Cocoa
import Vapor
import Muppet

struct AppInfo: Content {
    let pid: pid_t
    let name: String?
    let executable: URL?
    let bundleIdentifier: String?
    let bundle: URL?
    let isActive: Bool
    let isFinishedLaunching: Bool
    let isTerminated: Bool
    let isHidden: Bool
    let launchDate: Date?
    let ownsMenuBar: Bool
    let activationPolicy: NSApplication.ActivationPolicy.RawValue

    init(_ app: NSRunningApplication) {
        pid = app.processIdentifier
        name = app.localizedName
        executable = app.executableURL
        bundleIdentifier = app.bundleIdentifier
        bundle = app.bundleURL
        isActive = app.isActive
        isFinishedLaunching = app.isFinishedLaunching
        isTerminated = app.isTerminated
        isHidden = app.isHidden
        launchDate = app.launchDate
        ownsMenuBar = app.ownsMenuBar
        activationPolicy = app.activationPolicy.rawValue
    }
}

struct AppController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let apps = routes.grouped("apps")
        apps.get(use: list)
        apps.get(":identifier", use: getByIdentifier)
    }

    func list(_ req: Request) throws -> [AppInfo] {
        Muppet.Application.getRunningApps().map({ AppInfo($0) })
    }

    func getByIdentifier(_ req: Request) throws -> [AppInfo] {
        let identifier = req.parameters.get("identifier")!
        return Muppet.Application.getApps(bundleIdentifier: identifier).map({ AppInfo($0) })
    }
}
