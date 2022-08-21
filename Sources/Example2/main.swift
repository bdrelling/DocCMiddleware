import Vapor

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }

let mainPackage = "doccmiddleware"
let mainPackageName = "DocCMiddleware"
let pathToDocC = ".build/plugins/Swift-DocC/outputs/\(mainPackageName).doccarchive/"
let supportedPackages = [mainPackage]
let defaultAddress = "/\(mainPackageName)/documentation/\(mainPackage)/"

app.routes.get { req -> Response in
    req.redirect(to: defaultAddress)
}

app.routes.get("**") { req -> Response in
    var components = req.parameters.getCatchall()
    if components.first == mainPackageName {
        components.removeFirst()
    } else {
        return req.redirect(to: defaultAddress)
    }
    if components.count >= 2,
       ["documentation", "tutorials"].contains(components[0].lowercased()),
       supportedPackages.contains(components[1].lowercased()) {
        components = ["index.html"]
    }
    let pathSuffix = components.joined(separator: "/")
    let path = pathToDocC + pathSuffix
    if FileManager.default.fileExists(atPath: path) {
        return req.fileio.streamFile(at: path)
    } else {
        return req.redirect(to: defaultAddress)
    }
}

try app.run()
