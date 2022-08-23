// Copyright © 2022 Brian Drelling. All rights reserved.

import XCTVapor

extension XCTApplicationTester {
    @discardableResult
    func test(
        _ method: HTTPMethod,
        _ paths: [String],
        headers: HTTPHeaders = [:],
        body: ByteBuffer? = nil,
        file: StaticString = #file,
        line: UInt = #line,
        afterResponse: (XCTHTTPResponse) throws -> Void
    ) throws -> XCTApplicationTester {
        for path in paths {
            try self.test(
                method,
                path,
                headers: headers,
                body: body,
                file: file,
                line: line,
                beforeRequest: { _ in },
                afterResponse: afterResponse
            )
        }

        return self
    }
}
