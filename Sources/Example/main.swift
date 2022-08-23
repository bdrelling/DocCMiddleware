// Copyright © 2022 Brian Drelling. All rights reserved.

import DocCMiddleware
import Vapor

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }

app.middleware.use(DocCMiddleware(app: app, archive: .init(name: "DocCMiddleware", hostingBasePath: "DocCMiddleware")))

try app.run()
