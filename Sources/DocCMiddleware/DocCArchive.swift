import Vapor

public struct DocCArchive {
    /// The relative directory for this archive.
    let archiveDirectory: String
    
    /// The name of the `.doccarchive`.
    ///
    /// (eg. The name of `MyPackage.doccarchive` would be `"MyPackage"`.
    let archiveName: String
    
    /// The path to the `.doccarchive` on disk, relative to the `documentationDirectory` set when initializing a `DocCMiddleware`.
    let archivePath: String
    
    /// The base path for the archive. This is a relative path to your website, which is where your `.doccarchive` expects to serve files from.
    /// This is set via the `--hosting-base-path` option when generating a `.doccarchive`.
    ///
    /// (eg. If you used `--hosting-base-path MyPackage` to generate your `.doccarchive`,
    /// then your `.doccarchive` will serve files from `localhost:8080/MyPackage/`.)
    let hostingBasePath: String
    
    /// Whether or not the archive is static.
    /// This is set via the `--transform-for-static-hosting` option when generating a `.doccarchive`.
    let isStatic: Bool
    
    // FIXME: isStatic isn't working properly.
    public init(name: String, directory: String = "", hostingBasePath: String? = nil, isStatic: Bool = false) {
        self.archiveName = name
        self.archiveDirectory = directory
        self.isStatic = isStatic
        
        let filename = "\(self.archiveName).doccarchive"
        
        if directory.isEmpty {
            self.archivePath = filename
        } else {
            self.archivePath = "\(directory.trimmingTrailingSlashes())/\(filename)"
        }
        
        if let hostingBasePath = hostingBasePath {
            self.hostingBasePath = "\(hostingBasePath)/"
        } else {
            self.hostingBasePath = ""
        }
    }
}

extension DocCArchive: ExpressibleByStringLiteral, ExpressibleByStringInterpolation {
    public init(stringLiteral value: StringLiteralType) {
        self.init(name: value)
    }
}
