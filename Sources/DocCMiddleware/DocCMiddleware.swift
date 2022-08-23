// Copyright © 2022 Brian Drelling. All rights reserved.

import Vapor

/// Vapor middleware that serves files from a DocC archive.
///
/// _Developer Note: This file was copied as-is from its source rather than being pulled in as a dependency
/// because the source package includeds website modules as well, which we don't want._
///
/// Source: [JosephDuffy/VaporDocC](https://github.com/JosephDuffy/VaporDocC)
public struct DocCMiddleware: AsyncMiddleware {
    private let documentationDirectory: String
    private let archives: [DocCArchive]

    private let staticFiles = [
        "favicon.ico",
        "favicon.svg",
        "theme-settings.json",
    ]

    private let staticFilePrefixes = [
        "css/",
        "data/",
        "downloads/",
        "images/",
        "img/",
        "js/",
        "videos/",
        "index/",
    ]

    public init(documentationDirectory: String, archives: [DocCArchive]) {
        self.documentationDirectory = documentationDirectory
        self.archives = archives
    }

    public init(documentationDirectory: String, archives: [String]) {
        self.documentationDirectory = documentationDirectory
        self.archives = archives.map { .init(name: $0, hostingBasePath: $0) }
    }

    public init(documentationDirectory: String, archive: DocCArchive) {
        self.init(documentationDirectory: documentationDirectory, archives: [archive])
    }

    public init(documentationDirectory: String, archive: String) {
        self.init(documentationDirectory: documentationDirectory, archives: [.init(name: archive)])
    }

    public init(app: Application, archives: [DocCArchive]) {
        self.init(
            documentationDirectory: app.directory.workingDirectory.appending("Docs"),
            archives: archives
        )
    }

    public init(app: Application, archives: [String]) {
        self.init(
            documentationDirectory: app.directory.workingDirectory.appending("Docs"),
            archives: archives
        )
    }

    public init(app: Application, archive: DocCArchive) {
        self.init(app: app, archives: [archive])
    }

    public init(app: Application, archive: String) {
        self.init(app: app, archives: [archive])
    }

    public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        // Ensure our path begins with a leading "/".
        // If it doesn't, the route may be invalid.
        guard request.url.path.hasPrefix("/") else {
            return try await next.respond(to: request)
        }

        for archive in self.archives {
            if let response = try await self.tryRespond(to: request, for: archive) {
                return response
            }
        }

        return try await next.respond(to: request)
    }

    private func tryRespond(to request: Request, for archive: DocCArchive) async throws -> Response? {
        // Remove percent encoding from our path.
        guard var path = request.url.path.removingPercentEncoding else {
            return nil
        }

        // Remove the leading "/", just to make comparisons simpler.
        path.removeFirst()

        // Only continue of our path matches the hosting base path for this archive.
        guard archive.hostingBasePath.isEmpty || path == archive.hostingBasePath.trimmingTrailingSlashes() || path.hasPrefix(archive.hostingBasePath) else {
            return nil
        }

        guard !archive.isStatic else {
            // FIXME: Not exactly sure how a static DocC site needs to be served up, but I know it's not like this.
            return try await self.streamStaticFile(atPath: "index.html", for: archive, request: request)
        }

        // TODO: Evaluate with regex? This is broken, but close: ^[/]?[a-zA-Z]+[/]?(?:documentation|tutorials)?[/]?

        if path.trimmingTrailingSlashes() == archive.hostingBasePath.trimmingTrailingSlashes() || path.trimmingTrailingSlashes() == "\(archive.hostingBasePath)documentation" {
            // The path matches our hosting base path and/or documentation path, with or without trailing slashes.
            return request.redirect(to: "/\(archive.hostingBasePath)documentation/\(archive.archiveName.lowercased())")
        } else if path.trimmingTrailingSlashes() == "\(archive.hostingBasePath)/tutorials" {
            // The path matches our tutorials path, with or without trailing slashes.
            return request.redirect(to: "/\(archive.hostingBasePath)tutorials/\(archive.archiveName.lowercased())")
        } else if self.staticFileMatches(path: path, for: archive) {
            // The path matches a static file.
            return try await self.streamStaticFile(atPath: path, for: archive, request: request)
        } else if path == "/\(archive.hostingBasePath)data/documentation.json" {
            // The path matches the data.documentation.json within the .doccarchive.
            // This may no longer be required, but is at least meant to safeguard against documentation archives generated in early versions of Xcode 13.
            // If we find we don't really need this, we can rip it out.
            if let response = try? await self.streamStaticFile(atPath: "data/documentation.json", for: archive, request: request) {
                return response
            } else if let response = try? await self.streamStaticFile(atPath: "data/documentation/\(archive.archiveName.lowercased()).json", for: archive, request: request) {
                return response
            } else {
                throw Abort(.notFound)
            }
        } else {
            // The path has no explicit matches, so it should be served to the index.html within the archive.
            return try await self.streamStaticFile(atPath: "index.html", for: archive, request: request)
        }
    }

    private func matches(for regex: String, in text: String) throws -> [String] {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))

        return results.map {
            String(text[Range($0.range, in: text)!])
        }
    }

    private func firstMatch(for regex: String, in text: String) -> String? {
        try? self.matches(for: regex, in: text).first
    }

    private func streamStaticFile(atPath path: String, for archive: DocCArchive, request: Request) async throws -> Response {
        // Remove the hosting base path from the URL path.
        let relativePath = path.replacingOccurrences(of: "\(archive.hostingBasePath)", with: "")

        // Define our absolute file path.
        let absoluteFilePath = self.documentationDirectory
            .trimmingTrailingSlashes()
            .appendingPath(archive.archivePath)
            .appendingPath(relativePath)

        guard FileManager.default.fileExists(atPath: absoluteFilePath) else {
            throw Abort(.notFound)
        }

        return request.fileio.streamFile(at: absoluteFilePath)
    }

    private func staticFileMatches(path: String, for archive: DocCArchive) -> Bool {
        for file in self.staticFiles {
            if path == "\(archive.hostingBasePath)\(file)" || path == "\(archive.hostingBasePath)\(file)" {
                return true
            }
        }

        for filePrefix in self.staticFilePrefixes {
            if path.hasPrefix("\(archive.hostingBasePath)\(filePrefix)") || path.hasPrefix("\(archive.hostingBasePath)\(filePrefix)") {
                return true
            }
        }

        return false
    }
}
