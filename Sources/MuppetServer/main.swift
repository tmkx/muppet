import SwiftyJSON
import Vapor

let app = try await Application.make(.detect())

try configure(app)
try await app.execute()
