# DocCMiddleware

[![CI Status](https://github.com/bdrelling/DocCMiddleware/actions/workflows/tests.yml/badge.svg)](https://github.com/bdrelling/DocCMiddleware/actions/workflows/tests.yml)
[![Latest Release](https://img.shields.io/github/v/tag/bdrelling/DocCMiddleware?color=blue&label=latest)](https://github.com/bdrelling/DocCMiddleware/releases)
[![Swift Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbdrelling%2FDocCMiddleware%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/bdrelling/DocCMiddleware)
[![Platform Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbdrelling%2FDocCMiddleware%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/bdrelling/DocCMiddleware)
[![License](https://img.shields.io/github/license/bdrelling/DocCMiddleware)](https://github.com/bdrelling/DocCMiddleware/blob/main/LICENSE)

**DocCMiddleware** enables quick and efficient hosting of DocC documentation with Vapor.

:warning: This repository is a work in progress with many kinks to iron out and tests to write. This repository doesn't do much

## Usage

There are only a few quick steps required to host your DocC documentation with Vapor.

### 1. Generate Documentation

First, you need to generate a `.doccarchive`. You can do this directly from Xcode 13+, or you can leverage the [swift-docc-plugin](https://github.com/apple/swift-docc-plugin).

See [distributing documentation to external developers](https://developer.apple.com/documentation/xcode/distributing-documentation-to-external-developers) for an overview.

> Your `.doccarchive` can technically live anywhere within your Vapor workspace (it _does not_ have to live in the `Public/` directory), but the default location that the middleware looks for is `Docs/` in your workspace root.

### 2. Enable Middleware

Next, enable the middleware when your app is configuring, before you register routes. In a fresh Vapor project, this would take place in your `configure.swift` file.

To enable a single `.doccarchive` located at the root of your website, you just need to pass in the name of the archive.

```swift
app.middleware.use(DocCMiddleware(app: app, archive: "DocCMiddleware"))
```

You can also pass in a hosting base path, which **_must_** match the value you used when generating documentation with the `--hosting-base-path` option.

```swift
app.middleware.use(DocCMiddleware(app: app, archive: .init(name: "DocCMiddleware", hostingBasePath: "DocCMiddleware")))
```

> If you did not pass the `--hosting-base-path` option when generating documentation, **this will not work!**

If you're looking to host multiple `.doccarchive` files, you're in luck -- the middleware was designed to do just that.

```swift
app.middleware.use(DocCMiddleware(app: app, archives: ["Module1", "Module2", "Module3"]))
```

> Because multiple `.doccarchive` files could not be located simultaneouly at the root, the above syntax assumes that each module uses its own name as a hosting base path.

And if you'd like to keep your docs in a different directory, such as `Public/docs`, that's no problem either.

```swift
app.middleware.use(DocCMiddleware(documentationDirectory: app.directory.publicDirectory.appending("docs"), archive: "DocCMiddleware"))
```

### 3. View your Documentation

Finally, run your website and navigate to the documentation.

If you did not use `--hosting-base-path`, it can be seen at `localhost:8080` by default.

If you _did_ use `--hosting-base-path`, then the value you passed in is the route to navigate to. (eg. `--hosting-base-path MyModule` corresponds to `localhost:8080/MyModule`.)

> Routes will redirect to `<hosting-base-path>/documentation/MyModule` by default. This is built into the way the `.doccarchive` works and is not configurable at this time.

## To Do

- [x] Allow DocCMiddleware to serve up multiple `.doccarchive` files.
- [x] Fix sidebar rendering.
- [ ] Allow the Middleware to serve static `.doccarchive`s.
- [ ] Clean up, optimize, and test the middleware.

## Examples

See it in action!

- [https://audiokit.io](https://audiokit.io)

## Contributing

Discussions, issues, and pull requests are more than welcome!

## License

**InstrumentKit** is released under the MIT license. See [LICENSE](/LICENSE) for details.
