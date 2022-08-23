// Copyright © 2022 Brian Drelling. All rights reserved.

import DocCMiddleware
import XCTVapor

final class DocCMiddlewareTests: XCTestCase {
    func testDocCMiddleware() throws {
        let app = Application(.testing)
        defer { app.shutdown() }

        app.middleware.use(DocCMiddleware(app: app, archive: "DocCMiddleware"))

        try app.testable().test(.GET, [
            "",
            "/",
            "/documentation",
            "/documentation/",
        ]) { res in
            XCTAssertEqual(res.status, .seeOther)
        }

        try app.testable().test(.GET, "/documentation/doccmiddleware") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }

    func testDocCMiddlewareWithHostingBasePath() throws {
        let app = Application(.testing)
        defer { app.shutdown() }

        app.middleware.use(DocCMiddleware(app: app, archive: .init(name: "DocCMiddleware", hostingBasePath: "DocC")))

        try app.testable().test(.GET, [
            "",
            "/",
        ]) { res in
            XCTAssertEqual(res.status, .notFound)
        }

        try app.testable().test(.GET, [
            "/DocC",
            "/DocC/",
            "/DocC/documentation",
            "/DocC/documentation/",
        ]) { res in
            XCTAssertEqual(res.status, .seeOther)
        }

        try app.testable().test(.GET, "/DocC/documentation/doccmiddleware") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }
}
