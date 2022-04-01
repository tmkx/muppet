import Vapor

public func routes(_ app: Application) throws {
    try app.register(collection: AppController())
    try app.register(collection: WindowController())
    try app.register(collection: CDPController())
}
