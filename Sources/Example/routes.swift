import DocCMiddleware
import Vapor

// configures routes for your application
public func routes(_ app: Application) throws {
    app.get { req async -> String in
        """
        For the purpose of demonstration, this project hosts its documentation at the http://127.0.0.1:8080/DocCMiddleware endpoint.
        See the configure.swift file for more information.
        """
    }
}
